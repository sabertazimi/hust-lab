/*
 * SolarSystem.hpp
 * Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef SOLARSYSTEM_HPP
#define SOLARSYSTEM_HPP

#include <GL/glut.h>
#include "Stars.hpp"

class SolarSystem {
public:
    const static int STARS_NUM = 10;
    enum STARS { Sun, Mercury, Venus, Earth, Moon, Mars, Jupiter, Saturn, Uranus, Neptune };
    SolarSystem(void);
    ~SolarSystem(void);
    void onDisplay(void);
    void onUpdate(void);
    void onKeyboard(unsigned char key, int x, int y);
private:
    Star *stars[STARS_NUM];
    GLdouble viewX, viewY, viewZ;
    GLdouble centerX, centerY, centerZ;
    GLdouble upX, upY, upZ;
};

#endif /* !SOLARSYSTEM_HPP */
