#!/data/data/com.termux/files/usr/bin/bash
# ==============================================
#  setup.sh — একবার চালাবেন, তারপর আর লাগবে না
# ==============================================

echo "📦 দরকারি জিনিস ইন্সটল হচ্ছে..."
	
echo ""
echo "🔑 এখন আপনার GitHub Personal Access Token লাগবে।"
echo "   কিভাবে বানাবেন:"
echo "   1) github.com এ লগইন করুন"
echo "   2) Settings -> Developer settings -> Personal access tokens"
echo "      -> Tokens (classic) -> Generate new token"
echo "   3) 'repo' এবং 'workflow' checkbox টিক দিন"
echo "   4) Generate করে টোকেনটা কপি করুন (একবারই দেখাবে)"
echo ""
read -p "👉 এখানে GitHub Token পেস্ট করুন: " GH_TOKEN
read -p "👉 আপনার GitHub username দিন: " GH_USER

mkdir -p ~/.clonecfg
echo "GH_TOKEN=$GH_TOKEN" > ~/.clonecfg/config
echo "GH_USER=$GH_USER" >> ~/.clonecfg/config
chmod 600 ~/.clonecfg/config

echo ""
echo "✅ Setup শেষ! এখন deploy.sh চালান।"
