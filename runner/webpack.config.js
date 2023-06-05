const path = require('path');

module.exports = {
  entry: './runner.js',
  mode: 'production',
  output: {
    filename: 'runner.js',
    path: path.resolve(__dirname, '../docs/assets'),
  },
  experiments: {
    asyncWebAssembly: true,
  },
};
