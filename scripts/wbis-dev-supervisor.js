const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');

function logFile(name) {
  return path.join(root, name);
}

function start(name, command, args, cwd, outPath, errPath) {
  const out = fs.openSync(outPath, 'a');
  const err = fs.openSync(errPath, 'a');
  const child = spawn(command, args, {
    cwd,
    stdio: ['ignore', out, err],
    windowsHide: true,
  });

  fs.appendFileSync(
    logFile('wbis-supervisor.log'),
    `${new Date().toISOString()} started ${name} pid=${child.pid}\n`,
  );

  child.on('exit', (code, signal) => {
    fs.appendFileSync(
      logFile('wbis-supervisor.log'),
      `${new Date().toISOString()} ${name} exited code=${code} signal=${signal}\n`,
    );
  });

  return child;
}

start(
  'api',
  path.join(root, 'server', '.venv', 'Scripts', 'python.exe'),
  ['-m', 'uvicorn', 'app.main:app', '--host', '127.0.0.1', '--port', '8000'],
  path.join(root, 'server'),
  path.join(root, 'server', 'server.log'),
  path.join(root, 'server', 'server.err'),
);

start(
  'admin',
  'C:\\Windows\\System32\\cmd.exe',
  ['/c', 'npm.cmd', 'run', 'dev', '--', '--host', '127.0.0.1'],
  path.join(root, 'admin'),
  path.join(root, 'admin', 'admin-dev.log'),
  path.join(root, 'admin', 'admin-dev.err'),
);

setInterval(() => {
  fs.appendFileSync(
    logFile('wbis-supervisor.log'),
    `${new Date().toISOString()} heartbeat\n`,
  );
}, 60_000);
