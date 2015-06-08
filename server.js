// Generated by CoffeeScript 1.9.2
(function() {
  var Sequelize, app, bodyParser, connectDb, express, logger, moment, path, randomString, sequelize;

  express = require("express");

  path = require("path");

  logger = require("morgan");

  bodyParser = require("body-parser");

  Sequelize = require("sequelize");

  moment = require("moment");

  sequelize = new Sequelize("nba-agc", "root", "", {
    port: 3306,
    host: 'localhost',
    logging: false
  });

  connectDb = function() {
    return sequelize.sync().then(function(err) {
      if (!!err) {
        return console.log("Unable to connect to database");
      }
    });
  };

  connectDb();

  app = express();

  app.set('port', process.env.PORT || 3005);

  app.use(bodyParser.json());

  app.use(bodyParser.urlencoded({
    extended: true
  }));

  app.use(express["static"](path.join(__dirname, 'public'), {
    maxAge: 86400000
  }));

  app.listen(app.get('port'), function() {
    return console.log('Express server listening on port ' + app.get('port'));
  });

  app.use(logger('tiny'));

  app.get('/api', function(req, res) {
    return res.send({
      done: false
    });
  });

  app.post('/api/amountDue', function(req, res) {
    var theYear, txn_data;
    theYear = parseInt(req.body.yearCalled);
    txn_data = {
      amount: 50000,
      txn_ref: randomString(32).toUpperCase(),
      mToken: randomString(8),
      clientKey: "nba_agc"
    };
    console.log("For Transaction at ", new Date(), " ==> ", txn_data);
    return res.send(txn_data);
  });

  app.post('/callback', function(req, res) {
    console.log(req.body);
    return res.redirect(302, "/#callback");
  });

  app.get('*', function(req, res) {
    return res.redirect(302, "/#" + req.originalUrl);
  });

  app.use(function(err, req, res) {
    console.error(err.stack);
    return res.send({
      message: err.message
    }, 500);
  });

  randomString = function(length) {
    return Math.round(Math.pow(36, length + 1) - Math.random() * Math.pow(36, length)).toString(36).slice(1);
  };

}).call(this);
