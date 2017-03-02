/*
 * Tab.js
 * Copyright (C) 2017 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

const openTab = (evt, id) => {
  const tabcontent = document.getElementsByClassName('tabcontent');

  for (let i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = 'none';
  }

  document.getElementById(id).style.display = 'block';
}