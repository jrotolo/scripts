#!/bin/bash

mkdir -v actions components constants dispatcher stores utils
cd components
mkdir -v common session stories
cd ..
touch app.jsx routes.jsx
