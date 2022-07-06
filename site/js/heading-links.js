(function() {
  var els = document.querySelectorAll('.post-content [id]');
  var headings = Array.prototype.slice.call(els);

  headings.forEach(function(head) {
    var link = document.createElement('a');
    link.className = 'heading-link';
    link.href = '#' + head.id;

    head.appendChild(link);
  });
}());
