const electron = require('electron');

const app = electron.app;
const BrowserWindow = electron.BrowserWindow;

const path = require('path');
const url = require('url');

let timeWindow;
let cpuWindow;
let sumWindow;

/**
 * createWindow create 3 window for displaying time, cpu rate and sum
 * @return {[void]}
 */
const createWindow = () => {
  // timeWindow.webContents.openDevTools();
    
  timeWindow = new BrowserWindow({
    width: 800,
    height: 600
  });

  timeWindow.loadURL(url.format({
    pathname: path.join(__dirname, '../time.html'),
    protocol: 'file:',
    slashes: true
  }));

  timeWindow.on('closed', () => {
    timeWindow = null
  });
  
  cpuWindow = new BrowserWindow({
    width: 800,
    height: 600
  });

  cpuWindow.loadURL(url.format({
    pathname: path.join(__dirname, '../cpu.html'),
    protocol: 'file:',
    slashes: true
  }));

  cpuWindow.on('closed', () => {
    cpuWindow = null
  });
  
  sumWindow = new BrowserWindow({
    width: 800,
    height: 600
  });

  sumWindow.loadURL(url.format({
    pathname: path.join(__dirname, '../sum.html'),
    protocol: 'file:',
    slashes: true
  }));

  sumWindow.on('closed', () => {
    sumWindow = null
  });
}

app.on('ready', createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
});

app.on('activate', function () {
  if (timeWindow === null || cpuWindow === null || sumWindow === null) {
    createWindow()
  }
});

app.on('browser-window-created', (e, window) => {
  window.setMenu(null);
});

