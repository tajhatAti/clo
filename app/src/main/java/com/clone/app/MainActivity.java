package com.clone.app;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * ছোট্ট WebView অ্যাপ। কোনো external library লাগে না —
 * শুধু Android এর নিজস্ব Activity + WebView ব্যবহার করছি।
 */
public class MainActivity extends Activity {

    // এই লিংকটা বদলায়ে আপনার ওয়েবসাইট/অ্যাপের লিংক দিন
    private static final String TARGET_URL = "https://example.com";

    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        webView = findViewById(R.id.webview);

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setLoadWithOverviewMode(true);
        settings.setUseWideViewPort(true);
        settings.setSupportZoom(true);
        settings.setBuiltInZoomControls(true);
        settings.setDisplayZoomControls(false);

        // অ্যাপের ভেতরের লিংক অ্যাপেই খুলবে
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url == null) {
                    return false;
                }
                if (url.startsWith("http://") || url.startsWith("https://") || url.startsWith("file://")) {
                    return false; // WebView নিজেই খুলবে
                }
                // tel:, mailto:, whatsapp:// ইত্যাদি — ফোনের অন্য অ্যাপে পাঠিয়ে দেবে
                try {
                    startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
                } catch (Exception ignored) {
                    // কোনো অ্যাপ পাওয়া না গেলে চুপচাপ থাকবে (ক্র্যাশ করবে না)
                }
                return true;
            }
        });
        webView.setWebChromeClient(new WebChromeClient());

        // ফোন ঘোরালে (rotate) পেজ আবার লোড হবে না
        if (savedInstanceState != null) {
            webView.restoreState(savedInstanceState);
        } else {
            webView.loadUrl(TARGET_URL);
        }
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        webView.saveState(outState);
    }

    @Override
    public void onBackPressed() {
        // WebView তে আগের পেজ থাকলে সেখানে যাবে, না হলে অ্যাপ বন্ধ করবে
        if (webView != null && webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }
}
