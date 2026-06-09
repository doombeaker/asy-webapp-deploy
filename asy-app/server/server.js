import { existsSync, createReadStream, appendFile } from "fs";
import { dirname, resolve } from "path";
import { fileURLToPath } from "url";
import express from "express";
import expressStaticGzip from "express-static-gzip";
import { dateTime, dropRootPermission } from "./serverUtil.js";
import { reqTypeRouter, reqAnalyzer, delAnalyzer, usrConnect, requestResolver, writeAsyFile, downloadReq } from "./serverAnalyzer.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const APP_ROOT = resolve(__dirname, "..");

const defaultPort = 80;
const port = (process.env.ASYMPTOTE_PORT == undefined)? defaultPort: parseInt(process.env.ASYMPTOTE_PORT);

const app = express();

app.route("/")
.get(express.static(APP_ROOT + "/build"))
.post(reqTypeRouter(), usrConnect(APP_ROOT), reqAnalyzer(APP_ROOT), writeAsyFile(APP_ROOT), requestResolver())
.post(reqTypeRouter(), (req, res, next) => {
  console.log(req.body);
  next();
})


app.route("/delete")
.post(express.text(), delAnalyzer(APP_ROOT));

app.route("/logo3d.html")
.get(expressStaticGzip(APP_ROOT + "/build"));

app.use("/static/", function(req, res, next) {
  if (/\/(?:css|js|media)\//.test(req.originalUrl)) {
    let urlMatched = /^\/static\/(?:css|js|media)\/(.+\.(?:css|js|map|svg)$)/g.exec(req.originalUrl);
    if (urlMatched !== null && urlMatched[1] !== undefined) {
      res.sendFile(APP_ROOT + "/build" + urlMatched[0]);
    }
  }
})

app.use("/clients", (req, res, next) => {
  if (req.method === "GET") {
    const fileToServe = APP_ROOT + req.originalUrl;
    if (existsSync(fileToServe)) {
      createReadStream(fileToServe).pipe(res);
    }
  } else {
    next();
  }
});

app.route("/clients")
.post(express.urlencoded({extended: true}), reqAnalyzer(APP_ROOT) , downloadReq(APP_ROOT))
app.listen(port);
dropRootPermission(port);

process.on("uncaughtException", (err) => {
  const diagnose = {
    errorType: "An uncaught error moved to the top of the stack!",
    registerTime: dateTime().time,
    exception: err,
    errorStack: err.stack,
  },
  diagnoseJSON = JSON.stringify(diagnose).replace(/\\n/g,'\n') + '\n';
  const dest = APP_ROOT + "/logs/uncaughtExceptions"
  if (err) {
    appendFile(dest, diagnoseJSON, (err) => {
      if (err) {
          console.log("An error occurred while writing " + dest + ".");
      }
    })
  }
})
