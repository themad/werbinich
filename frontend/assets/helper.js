function orderofthecircle(list, r, x, y) {
  var lilist = list.find('li'),
      r = r,
      s = (2 * Math.PI) / lilist.length,
      minleft = 0,
      mintop = 0;

  lilist.each(function(i, linode) {
    var li = $(linode),
        liw = $(li).innerWidth(),
        lih = $(li).innerHeight()

    mintop = Math.min(mintop, Math.sin(i * s - (0.5 * Math.PI)) * r + y - (lih / 2) + r);
    minleft = Math.min(minleft, Math.cos(i * s - (0.5 * Math.PI)) * r + x - (liw / 2) + r);
  });

  lilist.each(function(i, linode) {
    var li = $(linode),
        liw = $(li).innerWidth(),
        lih = $(li).innerHeight()

    $(li).css({
      top:  (Math.sin(i * s - (0.5 * Math.PI)) * r + y - (lih / 2) + r + Math.abs(mintop)) + "px",
      left: (Math.cos(i * s - (0.5 * Math.PI)) * r + x - (liw / 2) + r + Math.abs(minleft)) + "px"
    })
  });
}