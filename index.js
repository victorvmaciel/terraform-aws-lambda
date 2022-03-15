// Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

var aws = require("aws-sdk");
var ses = new aws.SES({ region: "us-east-1" });

exports.handler = async function (event) {
  var params = {
    Destination: {
      ToAddresses: ["victorvmaciel@gmail.com"],
    },
    Message: {
      Body: {
        Text: {
          Data: 'name: ' + event.name + '\nemail: ' + event.email + '\nmessage: ' + event.message,
          Charset: 'utf-8'
        }
      },

      Subject: { Data: "ViktorOps New Message!" },
    },
    Source: "nonreply@viktorops.tech",
  };
 
  return ses.sendEmail(params).promise()
};