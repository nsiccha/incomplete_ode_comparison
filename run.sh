#!/usr/bin/env bash
poetry install && poetry run python3 py/lotka.py
julia --project=./jl jl/lotka.jl
convert +append figs/lotka_{jl,py}.png figs/lotka.png
