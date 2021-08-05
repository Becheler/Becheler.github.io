---
layout: blog
title: Derek et Léonin Site Map
description: software development concepts explained to the biologist.
---

# Site Map

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.date}} - {{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
