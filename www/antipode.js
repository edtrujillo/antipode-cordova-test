var exec = require('cordova/exec');

exports.coolMethod = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, 'antipode', 'fetchAntiPode', []);
};
