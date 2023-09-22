const functions = require("firebase-functions");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.NaturalLanguage = functions.storage.object().onFinalize((snapshot, context) => {
    `Please break down {{text${suffix}}} into words and make a entities list. (Return json type.entities:会社名,役職,名前,住所,電話番号,FAX,携帯電話番号,メールアドレス,ホームページ,事業内容)`
});
