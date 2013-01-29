
function tr(fun) {
    return (""+fun).replace(/    /g, "");
}

var doc = {_id:"_design/base", language:"javascript", views:{}};

doc.views.audio = {
    map:tr(function (doc) {
        if(doc.data.audio.length > 0)
            emit(doc._id, doc.data.audio);
    }),
};

doc.views.image = {
    map:tr(function (doc) {
        if(doc.data.image.length > 0)
            emit(doc._id, doc.data.image);
    }),
};

doc.views.pdf = {
    map:tr(function (doc) {
        if(doc.data.pdf.length > 0)
            emit(doc._id, doc.data.pdf);
    }),
};

doc.views.lists = {
    map:tr(function (doc) {
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
    }),
};

doc.views.files = {
    map: tr(function (doc) {
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
    }),
};

doc.views.tags = {
    map: tr(function (doc) {
        if(doc.data.tags.length > 0)
            emit(doc._id, doc.data.tags);
    }),
    reduce: tr(function (doc) {
        if(doc.data) {
            var prefix = doc.data.tags;
            if(prefix)
                emit(prefix, doc._id);
        }
    }),
};

doc.views.tagcount = {
    map: tr(function (doc) {
        if (doc.tags.length)
            emit(doc._id, doc.data.tags.length);
    }),
    reduce: tr(function(keys, values) {
        return sum(values);
    }),
};

doc.views.instances = {
    map: tr(function (doc) {
        if (doc && doc.data &&
            doc.data.instances[0] &&
            doc.data.instances[0].length > 0)
            emit(doc.data.instances, doc._id);
    }),
    reduce: tr(function(doc) {
        if(doc.data) {
            var prefix = doc.data.instances.length;
            if(prefix)
                emit(prefix, doc._id);
        }
    }),
};

doc.views.linkcount = {
    map: tr(function (doc) {
        if (doc.linknr)
            emit(doc._id, doc.data.linknr);
    }),
    reduce: tr(function(keys, values) {
        return sum(values);
    }),
};

doc.views.linkcountbig = {
    map: tr(function (doc) {
        if (doc.linknr > 1000)
            emit(doc._id, doc.data.linknr);
    }),
    reduce: tr(function(keys, values) {
        return sum(values);
    }),
};

doc.views.articles = {
    map: tr(function(doc) {
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
    }),
};


doc.views.scores = {
    map: tr(function (doc) {

var FuzzySet=(function(){return function(arr,useLevenshtein,gramSizeLower,gramSizeUpper){
    var fuzzyset = {
        version: '0.0.1c'
    };

    // default options
    arr = arr || [];
    fuzzyset.gramSizeLower = gramSizeLower || 2;
    fuzzyset.gramSizeUpper = gramSizeUpper || 3;
    fuzzyset.useLevenshtein = useLevenshtein || true;

    // define all the object functions and attributes
    fuzzyset.exactSet = {}
    fuzzyset.matchDict = {};
    fuzzyset.items = {};

    // helper functions
    var levenshtein = function(str1, str2) {
        var current = [], prev, value;

        for (var i = 0; i <= str2.length; i++)
            for (var j = 0; j <= str1.length; j++) {
            if (i && j)
                if (str1.charAt(j - 1) === str2.charAt(i - 1))
                value = prev;
                else
                value = Math.min(current[j], current[j - 1], prev) + 1;
            else
                value = i + j;

            prev = current[j];
            current[j] = value;
            }

        return current.pop();
    };

    // return an edit distance from 0 to 1
    var _distance = function(str1, str2) {
        if (str1 == null && str2 == null) throw 'Trying to compare two null values'
        if (str1 == null || str2 == null) return 0;
        str1 = String(str1); str2 = String(str2);

        var distance = levenshtein(str1, str2);
        if (str1.length > str2.length) {
            return 1 - distance / str1.length;
        } else {
            return 1 - distance / str2.length;
        }
    };
    var _nonWordRe = /[^\w, ]+/;

    var _iterateGrams = function(value, gramSize) {
        gramSize = gramSize || 2;
        var simplified = '-' + value.toLowerCase().replace(_nonWordRe, '') + '-',
            lenDiff = gramSize - simplified.length,
            results = [];
        if (lenDiff > 0) {
            for (var i = 0; i < lenDiff; ++i) {
                value += '-';
            }
        }
        for (var i = 0; i < simplified.length - gramSize + 1; ++i) {
            results.push(simplified.slice(i, i + gramSize))
        }
        return results;
    };

    var _gramCounter = function(value, gramSize) {
        gramSize = gramSize || 2;
        var result = {},
            grams = _iterateGrams(value, gramSize),
            i = 0;
        for (i; i < grams.length; ++i) {
            if (grams[i] in result) {
                result[grams[i]] += 1;
            } else {
                result[grams[i]] = 1;
            }
        }
        return result;
    };

    // the main functions
    fuzzyset.get = function(value, defaultValue) {
        var result = this._get(value);
        if (!result && defaultValue) {
            return defaultValue;
        }
        return result;
    };

    fuzzyset._get = function(value) {
        var normalizedValue = this._normalizeStr(value),
            result = this.exactSet[normalizedValue];
        if (result) {
            return [[1, result]];
        }
        var results = [];
        for (var gramSize = this.gramSizeUpper; gramSize > this.gramSizeLower; --gramSize) {
            results = this.__get(value, gramSize);
            if (results) {
                return results;
            }
        }
        return null;
    };

    fuzzyset.__get = function(value, gramSize) {
        var normalizedValue = this._normalizeStr(value),
            matches = {},
            gramCounts = _gramCounter(normalizedValue, gramSize),
            items = this.items[gramSize],
            sumOfSquareGramCounts = 0,
            gram,
            gramCount,
            i,
            index,
            otherGramCount;

        for (gram in gramCounts) {
            gramCount = gramCounts[gram];
            sumOfSquareGramCounts += Math.pow(gramCount, 2);
            if (gram in this.matchDict) {
                for (i = 0; i < this.matchDict[gram].length; ++i) {
                    index = this.matchDict[gram][i][0];
                    otherGramCount = this.matchDict[gram][i][1];
                    if (index in matches) {
                        matches[index] += gramCount * otherGramCount;
                    } else {
                        matches[index] = gramCount * otherGramCount;
                    }
                }
            }
        }

        function isEmptyObject(obj) {
            for(var prop in obj) {
                if(obj.hasOwnProperty(prop))
                    return false;
            }
            return true;
        }

        if (isEmptyObject(matches)) {
            return null;
        }

        var vectorNormal = Math.sqrt(sumOfSquareGramCounts),
            results = [],
            matchScore;
        // build a results list of [score, str]
        for (var matchIndex in matches) {
            matchScore = matches[matchIndex];
            results.push([matchScore / (vectorNormal * items[matchIndex][0]), items[matchIndex][1]]);
        }
        var sortDescending = function(a, b) {
            if (a[0] < b[0]) {
                return 1;
            } else if (a[0] > b[0]) {
                return -1;
            } else {
                return 0;
            }
        };
        results.sort(sortDescending);
        if (this.useLevenshtein) {
            var newResults = [],
                endIndex = results.length;
            for (var i = 0; i < endIndex; ++i) {
                newResults.push([_distance(results[i][1], normalizedValue), results[i][1]]);
            }
            results = newResults;
            results.sort(sortDescending);
        }
        var newResults = [];
        for (var i = 0; i < results.length; ++i) {
            if (results[i][0] == results[0][0]) {
                newResults.push([results[i][0], this.exactSet[results[i][1]]]);
            }
        }
        return newResults;
    };

    fuzzyset.add = function(value) {
        var normalizedValue = this._normalizeStr(value);
        if (normalizedValue in this.exactSet) {
            return false;
        }

        var i = this.gramSizeLower;
        for (i; i < this.gramSizeUpper + 1; ++i) {
            this._add(value, i);
        }
    };

    fuzzyset._add = function(value, gramSize) {
        var normalizedValue = this._normalizeStr(value),
            items = this.items[gramSize] || [],
            index = items.length;

        items.push(0);
        var gramCounts = _gramCounter(normalizedValue, gramSize),
            sumOfSquareGramCounts = 0,
            gram, gramCount;
        for (var gram in gramCounts) {
            gramCount = gramCounts[gram];
            sumOfSquareGramCounts += Math.pow(gramCount, 2);
            if (gram in this.matchDict) {
                this.matchDict[gram].push([index, gramCount]);
            } else {
                this.matchDict[gram] = [[index, gramCount]];
            }
        }
        var vectorNormal = Math.sqrt(sumOfSquareGramCounts);
        items[index] = [vectorNormal, normalizedValue];
        this.items[gramSize] = items;
        this.exactSet[normalizedValue] = value;
    };

    fuzzyset._normalizeStr = function(str) {
        if (Object.prototype.toString.call(str) !== '[object String]') throw 'Must use a string as argument to FuzzySet functions'
        return str.toLowerCase();
    };

    // return length of items in set
    fuzzyset.length = function() {
        var count = 0,
            prop;
        for (prop in this.exactSet) {
            if (this.exactSet.hasOwnProperty(prop)) {
                count += 1;
            }
        }
        return count;
    };

    // return is set is empty
    fuzzyset.isEmpty = function() {
        for (var prop in this.exactSet) {
            if (this.exactSet.hasOwnProperty(prop)) {
                return false;
            }
        }
        return true;
    };

    // return list of values loaded into set
    fuzzyset.values = function() {
        var values = [],
            prop;
        for (prop in this.exactSet) {
            if (this.exactSet.hasOwnProperty(prop)) {
                values.push(this.exactSet[prop])
            }
        }
        return values;
    };


    // initialization
    var i = fuzzyset.gramSizeLower;
    for (i; i < fuzzyset.gramSizeUpper + 1; ++i) {
        fuzzyset.items[i] = [];
    }
    // add all the items to the set
    for (i = 0; i < arr.length; ++i) {
        fuzzyset.add(arr[i]);
    }

    return fuzzyset;
};

})();

var density = function (arr) {
    var count = {}, res = [];
    arr.forEach(function (k) {
        count[k] = (count[k] || 0) + 1;
    });
    Object.keys(count).forEach(function (k) {
        res.push([count[k],k]);
    });
    res.sort(function(a, b) {
            if (a[0] < b[0]) {
                return 1;
            } else if (a[0] > b[0]) {
                return -1;
            } else {
                return 0;
            }
    });
    return res.map(function (v) {return v[1]});
};

        if (doc && doc.data &&
            doc.data.instances[0] &&
            doc.data.instances[0].length > 0) {
            var dense = density(doc.data.instances);
            var res = FuzzySet(dense).get(doc._id);
            if (res) emit(dense, res);
        }
    }),
    reduce: tr(function(doc) {
        if(doc.data) {
            var prefix = doc.data.instances.length;
            if(prefix)
                emit(prefix, doc._id);
        }
    }),
};

console.log(JSON.stringify(doc));
