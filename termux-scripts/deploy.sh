#!/data/data/com.termux/files/usr/bin/bash
# ==============================================
#  deploy.sh — এই একটা কমান্ডে সব হয়ে যাবে:
#  GitHub repo বানানো -> zip push -> Action চালানো
#  -> build শেষ হওয়া পর্যন্ত অপেক্ষা -> APK ডাউনলোড
# ==============================================
set -e

source ~/.clonecfg/config 2>/dev/null || {
  echo "❌ আগে setup.sh চালান।"
  exit 1
}

read -p "👉 নতুন Repo এর নাম দিন (যেমন: my-clone-app): " REPO_NAME
PROJECT_DIR="$(dirname "$0")/.."
cd "$PROJECT_DIR"

echo "🚀 GitHub এ repo বানানো হচ্ছে..."
curl -s -H "Authorization: token $GH_TOKEN" \
  -d "{\"name\":\"$REPO_NAME\",\"private\":false,\"auto_init\":false}" \
  https://api.github.com/user/repos > /dev/null

echo "📤 কোড push হচ্ছে..."
rm -rf .git
git init -q
git checkout -b main -q
git add .
git -c user.email="you@example.com" -c user.name="$GH_USER" commit -q -m "Clone app deploy"
git remote add origin "https://$GH_USER:$GH_TOKEN@github.com/$GH_USER/$REPO_NAME.git"
git push -u origin main -q -f

echo "⏳ GitHub Action চালু হওয়ার জন্য ১০ সেকেন্ড অপেক্ষা..."
sleep 10

echo "▶️  Build workflow ট্রিগার করা হচ্ছে..."
curl -s -X POST \
  -H "Authorization: token $GH_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$GH_USER/$REPO_NAME/actions/workflows/build-apk.yml/dispatches \
  -d '{"ref":"main"}'

sleep 8

echo "⏳ Build হচ্ছে, এতে ২-৪ মিনিট লাগতে পারে। অপেক্ষা করুন..."
RUN_ID=""
for i in $(seq 1 30); do
  RUN_ID=$(curl -s -H "Authorization: token $GH_TOKEN" \
    "https://api.github.com/repos/$GH_USER/$REPO_NAME/actions/runs?branch=main&per_page=1" \
    | jq -r '.workflow_runs[0].id')
  STATUS=$(curl -s -H "Authorization: token $GH_TOKEN" \
    "https://api.github.com/repos/$GH_USER/$REPO_NAME/actions/runs/$RUN_ID" \
    | jq -r '.status')
  CONCLUSION=$(curl -s -H "Authorization: token $GH_TOKEN" \
    "https://api.github.com/repos/$GH_USER/$REPO_NAME/actions/runs/$RUN_ID" \
    | jq -r '.conclusion')

  echo "   [$i/30] status: $STATUS"
  if [ "$STATUS" == "completed" ]; then
    break
  fi
  sleep 15
done

if [ "$CONCLUSION" != "success" ]; then
  echo "❌ Build ফেইল হয়েছে। GitHub এর Actions ট্যাবে গিয়ে লগ দেখুন:"
  echo "   https://github.com/$GH_USER/$REPO_NAME/actions"
  exit 1
fi

echo "✅ Build সফল! APK ডাউনলোড হচ্ছে..."

ARTIFACT_URL=$(curl -s -H "Authorization: token $GH_TOKEN" \
  "https://api.github.com/repos/$GH_USER/$REPO_NAME/actions/runs/$RUN_ID/artifacts" \
  | jq -r '.artifacts[0].archive_download_url')

mkdir -p ~/storage/downloads/CloneApps
curl -L -H "Authorization: token $GH_TOKEN" "$ARTIFACT_URL" -o /tmp/artifact.zip
unzip -o /tmp/artifact.zip -d ~/storage/downloads/CloneApps/ > /dev/null

echo ""
echo "🎉 শেষ! আপনার APK পাবেন:"
echo "   Internal Storage -> Download -> CloneApps"
echo ""
echo "GitHub repo লিংক: https://github.com/$GH_USER/$REPO_NAME"
