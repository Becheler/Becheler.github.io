---
layout: blog
title: Derek et Léonin Adventures
description: software development concepts explained to the biologist.
---

<ul class="post-list">
    {% for post in site.posts %}
      <li>
        <h2>
          <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        </h2>
        <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }},</span>
        <span class="post-meta">by</span>
        <span class="post-meta">{{ post.author }}</span>
      </li>

      <img src="{{ site.baseurl }}/draw/{{ post.featured_image }}">

      {{ post.excerpt }}
      <a class="btn-default" href="{{ post.url | prepend: site.baseurl }}">Continue reading</a>
    {% endfor %}
  </ul>
