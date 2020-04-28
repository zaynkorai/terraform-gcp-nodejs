sudo apt-get clean
sudo apt-get update
sudo apt-get -y upgrade

sudo apt install build-essential checkinstall libssl-dev

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

source ~/.bashrc
source ~/.bashrc

nvm install node
nvm install --lts

cd
sudo tee -a index.js <<EOF
// Load HTTP module
const http = require("http");
const server = http.createServer((req, res) => {
   res.writeHead(200, {'Content-Type': 'text/plain'});
   res.end('Hello World using Terraform\n');
});
server.listen(8080, "0.0.0.0", () => {
   console.log(`Server running at http://0.0.0.0:8080/`);
})
EOF


