function orderofthecircle(list, r, x, y) {
  var lilist = list.find('li'),
      r = r,
      s = (2 * Math.PI) / lilist.length,
      minleft = 0,
      mintop = 0,
      maxleft = 0,
      maxwidth = 0,
      maxheight = 0;

  lilist.each(function(i, linode) {
    var li = $(linode),
        lih = $(li).innerHeight(),
        liw = $(li).innerWidth();

    maxheight = Math.max(maxheight, lih);
    maxwidth = Math.max(maxwidth, liw);
  });
  $(lilist).css({
    width: maxwidth + "px",
    height: maxheight + "px",
  });

  lilist.each(function(i, linode) {
    var li = $(linode);

    mintop = Math.min(mintop, Math.sin(i * s - (0.5 * Math.PI)) * r + y - (maxheight / 2) + r);
    minleft = Math.min(minleft, Math.cos(i * s - (0.5 * Math.PI)) * r + x - (maxwidth / 2) + r);
  });

  x += list.offset().left;
  y += list.offset().top;

  lilist.each(function(i, linode) {
    var li = $(linode),
        left = Math.cos(i * s - (0.5 * Math.PI)) * r + x - (maxwidth / 2) + r + Math.abs(minleft);

    $(li).css({
      top:  (Math.sin(i * s - (0.5 * Math.PI)) * r + y - (maxheight / 2) + r + Math.abs(mintop)) + "px",
      left: left + "px"
    })

    maxleft = Math.max(maxleft, left);
  });

  list.css({
    width: (maxleft + maxwidth - x) + "px",
    height: (r * 2) + "px"
  });
}