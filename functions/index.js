const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { getFirestore } = require('firebase-admin/firestore');
const admin = require('firebase-admin');

// Admin SDK を初期化
admin.initializeApp();

// 必要なAPIをadminから取得して使う
const auth = admin.auth();

exports.deleteUserByDoc = onDocumentCreated(
  {
    region: 'asia-northeast1'
  },
  "delete_users/{docId}", async (event) => {
  const deleteDocument = event.data.data();
  const uid = deleteDocument.user_id;

  try {
    const db = getFirestore();
    const habitsCollection = db.collection('habits');
    const querySnapshot = await habitsCollection.where('user_id', '==', uid).get();

    const batch = db.batch();
    querySnapshot.forEach((doc) => {
      batch.delete(doc.ref);
    });

    await batch.commit();

    await auth.deleteUser(uid);
    console.log(`Successfully deleted user with UID: ${uid}`);
  } catch (error) {
    console.error(`Error deleting user with UID: ${uid}`, error);
  }
});