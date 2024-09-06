const functions = require('firebase-functions');
const admin = require('firebase-admin');

// firebase-adminの初期化
admin.initializeApp();

exports.deleteUser = functions
  .region('asia-northeast1') // リージョンの指定
  .firestore.document('delete_users/{docId}') // トリガーとなるFirestoreのドキュメントパス
  .onCreate(async (snap, context) => {
    const deleteDocument = snap.data(); // ドキュメントデータの取得
    const uid = deleteDocument.user_id; // 削除するユーザーのUIDを取得

    try {
      // Firestoreからhabitsデータの削除
      const habitsCollection = admin.firestore().collection('habits');
      // uidとhabitsコレクションのuser_idフィールドが一致するドキュメント取得
      const query = habitsCollection.where('user_id', '==', uid);
      const querySnapshot = await query.get();
      // バッチ作成
      const batch = admin.firestore().batch();
      // 一致するドキュメントを削除
      querySnapshot.forEach(doc => {
        batch.delete(doc.ref);
      });

      await batch.commit();

      // Firebase Authenticationのユーザーを削除
      await admin.auth().deleteUser(uid);
      console.log(`Successfully deleted user with UID: ${uid}`);
    } catch (error) {
      console.error(`Error deleting user with UID: ${uid}`, error);
    }
  });