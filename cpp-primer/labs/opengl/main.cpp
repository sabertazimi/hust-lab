/*
 * main.cpp
 * Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include <GL/glut.h>
#include "SolarSystem.hpp"

const int WINDOW_X_POS = 50;
const int WINDOW_Y_POS = 50;
const int WIDTH = 700;
const int HEIGHT = 700;

SolarSystem solarsystem;

void onDisplay(void) {
    solarsystem.onDisplay();
}

void onUpdate(void) {
    solarsystem.onUpdate();
}

void onKeyboard(unsigned char key, int x, int y) {
    solarsystem.onKeyboard(key, x, y);
}

int main(int argc, char **argv) {
    glutInit(&argc, argv);

    // double buffer window
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
    glutInitWindowPosition(WINDOW_X_POS, WINDOW_Y_POS);
    glutInitWindowSize(WIDTH, HEIGHT);
    glutCreateWindow("Solar System");

    // callback functions
    glutDisplayFunc(onDisplay);
    glutIdleFunc(onUpdate);
    glutKeyboardFunc(onKeyboard);

    glutMainLoop();
    return 0;
}
