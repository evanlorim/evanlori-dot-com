---
layout: code-post
title: Evolving Waves
subtitle: Experiment with perlin waves
images:
  - public_id: code/evolving-waves
github_link: https://gist.github.com/evanlorim/0fcbae39a9d14bb720184562ecbb1396
codepen_link: https://codepen.io/evanlorim/full/eVWVwK
categories: [code, frontend]
tags: [html, css, js, p5]
date: 2018-02-12
featured: true
---
This is my first experiment with trying to digitally recreate a motif I use in many of my drawings.

I wanted to make a program that would take one wave and gradually change it until it becomes another wave. I chose to model perlin waves -- as they were most similar to the shapes I draw. You can see an example of the motif I'm modelling  [here]({% post_url 2018-02-03-untitled_pattern_1 %})). I chose to use [p5js](https://p5js.org/) because it came with a builtin perlin wave function and seemed the easiest to prototype with. 

This program draws a series of perlin waves with one alpha wave (the top wave) and one omega wave (the bottom one). Every wave inbetween is an interpolation calculated by multiplying the difference between waves (delta) by fraction representing the percentage of the way the wave is between alpha and omega. 

The program allows you to manipulate a number of variables via sliders: 
1. **x-increment** - x is the first value used in the 2D perlin wave function. The x-increment is the difference in x-values between subsequent calls to the perlin wave function within a single frame.  
2. **y-increment** - y is the second value used in the 2D perlin wave function. The y-increment is the difference in y-values between subsequent calls to the perlin wave function between frames. 
3. **t-increment** - t is the value for the x-coordinate of the output wave. Increasing the increment decreases the number of calls to the perlin wave in a single frame (and vise-versa).
4. **slice-increment** - this variable determined the number of wave generations there are between alpha and omega. Essentially the height of the drawing space is taken and divided by the slice-increment. This determined the number of generations that will be drawn to the screen. 
5. The **alpha and omega waves** are two different perlin wave functions read with different initial y values (alpha is 0, omega is a large number like 100000). I decided to not have a slider for this as the results weren't interesting.


You can check out the embedded demo of this code below if you are on desktop, or check it out on [Codepen]({page.codepen_link}) or [GitHub]({page.github_link}).

{% include embedded-demo.html link='demos/evolving-waves.html' %}

If you want to see Here are my other work in digitally recreating my drawing style - here are my [second]({% post_url 2018-02-18-wave_art_generator %}) and [third]({% post_url 2018-03-26-becoming_bands %}) experiments. 
