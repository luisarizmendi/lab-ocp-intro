/*
 * Copyright (c) 2012-2019 Red Hat, Inc.
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   Red Hat, Inc. - initial API and implementation
 */

/*eslint-env node*/

//Use port 8080 in OpenShift
//Use port 3000 in code ready workspaces
var port = 8080;
var express = require('express');
var app = express();
var PropertiesReader = require('properties-reader');
const fs = require('fs')

const path = 'app/ui.properties'

try {
  if (fs.existsSync('/etc/node-app/node-app.config')) {
    var properties = PropertiesReader('/etc/node-app/node-app.config');
  }
  else if (fs.existsSync('app/ui.properties'))  {
    var properties = PropertiesReader('app/ui.properties');
  }
} catch(err) {
  console.error(err)
}


app.get('/', function (req, res) {
     res.writeHead(200, {'Content-Type': 'text/html'});
      res.write('<html><head><title></title></head>');
      res.write('<body bgcolor="' + properties.get('color') + '">');
      res.write('<h1>' + process.env.BACKGROUND_MSG + '</h1>');
      res.write('</body>');
      res.end('\n');
});


app.listen(port, function () {
  console.log('Configmap-demo listening on port '+port+'!');
});
