
var doc = {_id:"_design/base", language:"javascript", views:{}};

doc.views.audio = {
    map: ""+function (doc) {
        if(doc.data.audio.length > 0)
            emit(doc._id, doc.data.audio);
    },
};

doc.views.image = {
    map: ""+function (doc) {
        if(doc.data.image.length > 0)
            emit(doc._id, doc.data.image);
    },
};

doc.views.pdf = {
    map: ""+function (doc) {
        if(doc.data.pdf.length > 0)
            emit(doc._id, doc.data.pdf);
    },
};

doc.views.lists = {
    map: ""+function (doc) {
        var test, qq = [];
        if(doc.data.links.length) {
            test = doc.data.links;
            for (i = 0; i < test.length; i++) {
                if(test[i].match("List_of_")) {
                    qq[qq.length] = test[i];
                }
            }
        }
        if(qq.length)
            emit(qq, doc._id);
    },
};

doc.views.files = {
    map: ""+function (doc) {
        var test, qq = [];
        if(doc.data.links.length) {
            test = doc.data.links;
            for (i = 0; i < test.length; i++) {
                if(test[i].match("File:")) {
                    qq[qq.length] = test[i];
                }
            }
        }
        if(qq.length)
            emit(qq, doc._id);
    },
};

doc.views.tags = {
    map: ""+function (doc) {
        if(doc.data.tags.length > 0)
            emit(doc._id, doc.data.tags);
    },
    reduce: ""+function (doc) {
        if(doc.data) {
            var prefix = doc.data.tags;
            if(prefix)
                emit(prefix, doc._id);
        }
    },
};

doc.views.tagcount = {
    map: ""+function (doc) {
        if (doc.tags.length)
            emit(doc._id, doc.data.tags.length);
    },
    reduce: ""+function(keys, values) {
        return sum(values);
    },
};

doc.views.instances = {
    map: ""+function (doc) {
        if (doc && doc.data &&
            doc.data.instances[0] &&
            doc.data.instances[0].length > 0)
            emit(doc.data.instances, doc._id);
    },
    reduce: ""+function(doc) {
        if(doc.data) {
            var prefix = doc.data.instances.length;
            if(prefix)
                emit(prefix, doc._id);
        }
    },
};

doc.views.linkcount = {
    map: ""+function (doc) {
        if (doc.linknr)
            emit(doc._id, doc.data.linknr);
    },
    reduce: ""+function(keys, values) {
        return sum(values);
    },
};

doc.views.linkcountbig = {
    map: ""+function (doc) {
        if (doc.linknr > 1000)
            emit(doc._id, doc.data.linknr);
    },
    reduce: ""+function(keys, values) {
        return sum(values);
    },
};

doc.views.articles = {
    map: ""+function(doc) {
        var mediaratio = 0;
        if (doc.data) {
            var links = {};
            if(doc.data.pdf) {
                links.pdf = [];
                for(var u in doc.data.pdf) {
                    links.pdf.push(doc.data.pdf[u]);
                }
            }
            if(doc.data.image) {
                links.image = [];
                for(var u in doc.data.image) {
                    mediaratio++;
                    links.image.push("http://" + doc.data.image[u]);
                }
            }
            if(doc.data.headings) {
                links.headings = doc.data.headings;
            }
            if(doc.data.categories) {
                links.categories = doc.data.categories;
            }
            if(doc.data.members) {
                links.members = doc.data.members;
            }
            if(doc.data.cat) {
                links.cat = doc.data.cat;
            }
            if(doc.data.list) {
                links.list = doc.data.list;
            }
            if(doc.data.src) {
                links.src = doc.data.src;
            }
            if(doc.data.related) {
                links.related = doc.data.related;
            }
            if(doc.data.audio) {
                links.audio = [];
                for(var u in doc.data.audio) {
                    if(doc.data.audio[u].match(/^\/\/upload/)) {
                        mediaratio++;
                        links.audio.push("http:" + doc.data.audio[u]);
                    }
                }
            }
            emit(doc.data.instances, [doc._id, {
                media:mediaratio,
                instance:doc.data.members.length,
                tags:doc.data.tags.length,
                spawn:doc.data.linknr,
            }, doc.data.audio, links]);
        }
    },
};

console.log(JSON.stringify(doc));
