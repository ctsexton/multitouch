# Multitouch Library for Sensel Morph & Audio
The point of this repository is to build a class library, initially, to use the Sensel Morph in SuperCollider. Once we have that working, we'll see where else the project takes us. Currently there is a simple example using the Sensel Python API to send touch data via OSC to SuperCollider. Lots of interesting work remains to be done.

## Getting Started
1. Clone this repo:
`git clone https://github.com/ctsexton/multitouch.git`
2. Then you need to install the sensel-api (follow instructions here: http://guide.sensel.com/api/#installation).
3. Create & start python virtual environment:
```
python3 -m venv venv
source venv/bin/activate
```
4. Install python dependencies:
`pip install -r requirements.txt`
Note: To run the supercollider example you will also need to install SuperCollider.
5. Run the example:
`bash start.sh`

## Contributing
If you want to contribute, I am pretty open to new tools and ideas. So feel free to add anything you think is related. I just ask that you provide a working example for each new class/synth/tool you contribute and document why/how it is useful:

The process is simple:
1. **Fork** this repository to your GitHub account.
2. **Write** your code or documentation.
3. **Push** your changes to your forked repository.
4. Make a **Pull Request** to this repository.
