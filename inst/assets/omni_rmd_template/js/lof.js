Paged.registerHandlers(class extends Paged.Handler {
  constructor(chunker, polisher, caller) {
    super(chunker, polisher, caller);    this.prefixes = [];
  }  retrieveUniquePrefixes(content) {
    const els = content.querySelectorAll('.figure > img[data-prefix] + p.caption, .figure > p.caption + img[data-prefix]');
    // retrieve all prefixes
    let prefixes = Array.from(els)
                        .map(el => el.parentNode.querySelector('img').dataset.prefix);
    // get unique prefixes
    this.prefixes = [...new Set(prefixes)];
  }  beforeParsed(content) {
    this.retrieveUniquePrefixes(content);
    for (const prefix of this.prefixes) {
      const els = content.querySelectorAll('.figure > img[data-prefix="' + prefix + '"] + p.caption, .figure > p.caption + img[data-prefix="' + prefix + '"]');      for (let i = 0; i < els.length; i++) {
        const newLabel = prefix + ' ' + (i + 1);
        const caption = els[i].parentNode.querySelector('p.caption');
        caption.textContent = caption.textContent.replace(/[^:]*/, newLabel);
        const figure = caption.parentNode;
        const id = figure.firstElementChild.id;
        const lofEntry = content.querySelector('#LOF a[href*="' + id +'"]');
        lofEntry.childNodes[0].textContent = lofEntry.childNodes[0].textContent
                                                                   .replace(/\d*.\d*/, newLabel + ':');      }
    }
  }
});
