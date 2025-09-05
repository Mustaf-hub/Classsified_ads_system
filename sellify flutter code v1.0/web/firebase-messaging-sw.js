importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

const firebaseConfig = {
    apiKey: "AIzaSyBbLUqwUcgskd_wfabUxb98-4Y54qC0aK4",
    authDomain: "redbus-3ec46.firebaseapp.com",
    projectId: "redbus-3ec46",
    storageBucket: "redbus-3ec46.firebasestorage.app",
    messagingSenderId: "319710447950",
    appId: "1:319710447950:web:d6eaa0da10d206ada2f61f",
    measurementId: "G-2YB48YDMK0"
}

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
    console.log("[firebase-messaging-sw.js] Received background message ", payload);
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: "/firebase-logo.png",
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
