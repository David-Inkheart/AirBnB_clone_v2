#!/usr/bin/python3
"""starts a Flask web application"""
from flask import Flask, escape

app = Flask(__name__)


@app.route('/', strict_slashes=False)
def index_page():
    """Display 'Hello HBNB!'
    """
    return 'Hello, HBNB!'


@app.route('/hbnb', strict_slashes=False)
def hbnb_page():
    """Display 'HBNB'
    """
    return 'HBNB!'


@app.route('/c/<text>', strict_slashes=False)
def c_page(text):
    """Display 'C' followed by the value of the text variable
    """
    return 'C ' + text.replace('_', ' ')


@app.route('/python/', strict_slashes=False)
@app.route('/python/<text>', strict_slashes=False)
def python_text(text="is cool"):
    """
    display “Python ”, followed by the value of the
    text variable (replace underscore _ symbols with a space)
    """
    return 'Python ' + text.replace('_', ' ')


@app.route('/number/<int:n>', strict_slashes=False)
def verify_int(n):
    """
    display “n is a number” only if n is an integer
    """
    return '%d is a number' % n


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
