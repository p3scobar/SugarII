const functions = require('firebase-functions');
const admin = require('firebase-admin');
const StellarSDK = require('stellar-sdk');

StellarSDK.Network.useTestNetwork();

var server = new StellarSdk.Server('https://horizon-testnet.stellar.org');
var sourceSecretKey = 'SCD2YCUK2KFRP3IA7VLZAPFDOJDEU2NB3X4F3JQGNQZZKZE55FAE2TOU';
var sourceKeyPair = StellarSDK.Keypair.fromSecret(sourceSecretKey);
var sourcePublicKey = sourceKeyPair.publicKey();

admin.initializeApp();

exports.pushStatus = functions.firestore
  .document('status/{id}')
    .onCreate((snap, context) => {

      const status = snap.data();
      console.log('status: ', status);
      const statusId = status.id;
      console.log('statusId: ', statusId);
      const userId = status.userId;

      var db = admin.firestore();
      var followersRef = db.collection('users').doc(userId).collection('followers');

      var followers = followersRef.get()
          .then(snapshot => {
            snapshot.forEach(doc => {
              postToTimeline(doc);
            });
          })
          .catch(err => {
            console.log('Error getting documents', err);
          });

          function postToTimeline(doc) {
            var followerId = doc.id;
            console.log(followerId);
            var newDoc = db.collection('users').doc(followerId).collection('timeline').doc(statusId);

            newDoc.set(status).then(res => {
              console.log('Database Write: ', 'userId: ', followerId, 'RESPONSE: ', res);
            });
          }

        // return followers;
        return new Promise(function(resolve, reject) {
          setTimeout(resolve, 100);
        });
    });




    exports.deleteStatus = functions.firestore
      .document('status/{id}')
        .onDelete((snap, context) => {

          const status = snap.data();
          const statusId = status.id;
          const userId = status.userId;

          var db = admin.firestore();
          var followersRef = db.collection('users').doc(userId).collection('followers');

          var followers = followersRef.get()
              .then(snapshot => {
                snapshot.forEach(doc => {
                  removeFromTimeline(doc);
                });
              })
              .catch(err => {
                console.log('Error getting documents', err);
              });

              function removeFromTimeline(doc) {
                var followerId = doc.id;
                console.log(followerId);
                var deleteDoc = db.collection('users').doc(followerId).collection('timeline').doc(statusId).delete();

                deleteDoc.then(res => {
                  console.log('Database Write: ', 'userId: ', followerId, 'RESPONSE: ', res);
                });
              }

            // return followers;
            return new Promise(function(resolve, reject) {
              setTimeout(resolve, 100);
            });
        });



      exports.issueDebt = functions.firestore
      .document('issue/{id}')
      .onCreate((snap, context) => {

        const data = context.data();
        const receiverPublicKey = data.publicKey;
        const amount = data.amount;

        server.loadAccount(sourcePublicKey)
        .then(function(account) {
          var transaction = new StellarSDK.TranactionBuilder(account)

          .addOperation(StellarSDK.Operation.payment({
            destination: receiverPublicKey,
            asset: StellarSDK.Asset.native(),
            amount: amount,
          }))
          .build();

          transaction.sign(sourceKeyPair);

          console.log(transaction.toEnvelope().toXDR('base64'));

          server.submitTransaction(transaction)
          .then(function(transactionResult) {
            console.log(JSON.stringify(transactionResult, null, 2));
            console.log('\nSuccess! View the transaction at: ');
            console.log(transactionResult._links.transaction.href);
          })
          .catch(function(err) {
            console.log('An error has occured');
            console.log(err);
          });
        })
        .catch(function(e) {
          console.error(e);
        });

      });



// This function seeks to create a follower on the current user when another user adds a user to their 'following'.
// THis is necessary because user's can't modify each other per security rules.

  // exports.addFollower = functions.firestore
  //   .document('users/{userId}/following/{id}')
  //   .onWrite((snap, context) => {
  //       const data = snap.after.data();
  //       const id = data.id;
  //       const userId = context.params.id;
  //
  //       console.log(data);
  //       var db = admin.firestore;
  //       var follower = db.collection('users').doc(id).collection('followers').doc(userId);
  //
  //       return follower.set(data).then(res => {
  //         console.log('Database Write: ', 'userId: ', userId, 'RESPONSE: ', res);
  //       });
  //   });




  // N E W  U S E R

  // exports.authAction = functions.auth.user().onCreate((userRecord, context) => {
  //
  // });
