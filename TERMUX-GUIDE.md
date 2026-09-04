# Termux দিয়ে One-Click Build — কোনো কম্পিউটার লাগবে না

শুধু ফোন + Termux দিয়ে সব হয়ে যাবে: repo বানানো, কোড push, GitHub Action এ
build চালু হওয়া, এবং শেষে APK সরাসরি আপনার ফোনে ডাউনলোড হয়ে যাওয়া।

## জিনিস যা লাগবে
- Termux app (F-Droid থেকে নামান, Play Store এর পুরনোটা কাজ করে না)
- একটা GitHub একাউন্ট (ফ্রি)

## ধাপ ১ — এই zip টা ফোনে আনুন
এই CloneApp-Template.zip ফাইলটা ফোনের **Download** ফোল্ডারে রাখুন।

## ধাপ ২ — Termux খুলে কমান্ড দিন
```bash
termux-setup-storage
cp /sdcard/Download/CloneApp-Template.zip ~/
cd ~
unzip CloneApp-Template.zip
cd CloneApp/termux-scripts
chmod +x setup.sh deploy.sh
```

## ধাপ ৩ — একবারের জন্য setup চালান
```bash
./setup.sh
```
এটা আপনাকে GitHub Token চাইবে (Token বানানোর নিয়ম স্ক্রিপ্টের ভেতরেই লেখা আছে)।
একবার দিলেই সেভ হয়ে থাকবে, পরে আর লাগবে না।

## ধাপ ৪ — App name/color বদলে দিন (আগের মতই)
- `CloneApp/app/src/main/res/values/strings.xml` → app name
- `CloneApp/app/src/main/res/values/colors.xml` → color hex code
- `CloneApp/app/src/main/java/com/clone/app/MainActivity.java` → ওয়েবসাইট লিংক

Termux এ ফাইল এডিট করতে চাইলে `nano` ব্যবহার করুন, যেমন:
```bash
cd ~/CloneApp
nano app/src/main/res/values/strings.xml
```
(এডিট শেষে Ctrl+O চেপে Save, Ctrl+X চেপে বের হন)

## ধাপ ৫ — One-click deploy!
```bash
cd ~/CloneApp/termux-scripts
./deploy.sh
```
এটা নিজে নিজে করবে:
1. ✅ GitHub এ নতুন repo বানাবে
2. ✅ পুরো কোড push করবে
3. ✅ GitHub Actions build ট্রিগার করবে
4. ✅ বিল্ড শেষ হওয়া পর্যন্ত অপেক্ষা করবে (২-৪ মিনিট)
5. ✅ APK ডাউনলোড করে সরাসরি ফোনে রেখে দেবে

**APK পাবেন:** Internal Storage → Download → CloneApps ফোল্ডারে

## নতুন আরেকটা অ্যাপ বানাতে চাইলে
আবার শুধু ধাপ ৪ আর ৫ রিপিট করুন — নতুন app name/color/link দিয়ে
`./deploy.sh` চালান, নতুন repo নাম দিন, ব্যস — নতুন APK চলে আসবে।

## সমস্যা হলে
- `Permission denied` দেখালে: `chmod +x setup.sh deploy.sh` আবার চালান
- Build fail করলে: স্ক্রিপ্ট শেষে যে GitHub লিংক দেখাবে, ওখানে গিয়ে
  Actions ট্যাবে red ❌ চিহ্নে ক্লিক করে error log পড়ুন
- Token ভুল দিলে: `nano ~/.clonecfg/config` দিয়ে এডিট করে ঠিক করুন
