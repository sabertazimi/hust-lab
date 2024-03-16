/*
 * Stars.hpp
 * Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef STARS_HPP
#define STARS_HPP

#include <GL/glut.h>

class Star {
public:
    GLfloat radius;
    GLfloat speed, selfSpeed;
    GLfloat distance;
    GLfloat rgbaColor[4];
    Star * parentStar;

    Star(GLfloat radius, GLfloat distance, GLfloat speed, GLfloat selfSpeed, Star *parent);
    void drawStar(void);
    virtual void draw(void) { drawStar(); }
    virtual void update(long timeSpan);
protected:
    GLfloat alphaSelf, alpha;
};

class Planet : public Star {
public:
    Planet(GLfloat radius, GLfloat distance, GLfloat speed, GLfloat selfSpeed, Star * parent, GLfloat rgbColor[3]);
    void drawPlanet(void);
    virtual void draw(void) { drawPlanet(); drawStar(); }
};

class LightPlanet : public Planet {
public:
    LightPlanet(GLfloat Radius, GLfloat Distance, GLfloat Speed, GLfloat SelfSpeed, Star * Parent, GLfloat rgbColor[]);
    void drawLight(void);
    virtual void draw(void) { drawLight(); drawPlanet(); drawStar(); }
};

#endif /* !STARS_HPP */
