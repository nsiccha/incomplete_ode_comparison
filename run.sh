#!/usr/bin/env bash
poetry install && poetry run python3 py/lotka.py
julia --threads 6 --project=./jl jl/lotka_static.jl
convert +append figs/lotka_{py,jl}.png figs/lotka.png
