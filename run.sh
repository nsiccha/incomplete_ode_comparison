#!/usr/bin/env bash
poetry run python3 py/lotka.py
julia --project=./jl jl/init.jl
convert +append figs/lotka_{jl,py}.png figs/lotka.png
