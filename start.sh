#!/bin/bash

source venv/bin/activate
sclang synth-example.scd &
python main.py
