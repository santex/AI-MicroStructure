(function(){

    var LIMIT = window.LIMIT = {rel:16, node:10};
  Renderer = function(canvas){
    canvas = $(canvas).get(0)
    var ctx = canvas.getContext("2d")
    var particleSystem = null

    var palette = {
      "Africa": "#D68300",
      "Asia": "#4D7A00",
      "Europe": "#6D87CF",
      "North America": "#D4E200",
      "Oceania": "#4F2170",
      "South America": "#CD2900"
    }

    var that = {
      init:function(system){
        particleSystem = system
        particleSystem.screen({padding:[100, 60, 60, 60], // leave some space at the bottom for the param sliders
                              step:.02}) // have the ‘camera’ zoom somewhat slowly as the graph unfolds
       $(window).resize(that.resize)
       that.resize()

       that.initMouseHandling()
      },
      redraw:function(){
        if (particleSystem===null) return

        ctx.clearRect(0,0, canvas.width, canvas.height)
        ctx.strokeStyle = "#d3d3d3"
        ctx.lineWidth = 1
        ctx.beginPath()
        particleSystem.eachEdge(function(edge, pt1, pt2){
          // edge: {source:Node, target:Node, length:#, data:{}}
          // pt1:  {x:#, y:#}  source position in screen coords
          // pt2:  {x:#, y:#}  target position in screen coords

          var weight = null // Math.max(1,edge.data.border/100)
          var color = null // edge.data.color
          if (!color || (""+color).match(/^[ \t]*$/)) color = null

          if (color!==undefined || weight!==undefined){
            ctx.save()
            ctx.beginPath()

            if (!isNaN(weight)) ctx.lineWidth = weight

            if (edge.source.data.region==edge.target.data.region){
              ctx.strokeStyle = palette[edge.source.data.region]
            }

            // if (color) ctx.strokeStyle = color
            ctx.fillStyle = null

            ctx.moveTo(pt1.x, pt1.y)
            ctx.lineTo(pt2.x, pt2.y)
            ctx.stroke()
            ctx.restore()
          }else{
            // draw a line from pt1 to pt2
            ctx.moveTo(pt1.x, pt1.y)
            ctx.lineTo(pt2.x, pt2.y)
          }
        })
        ctx.stroke()

        particleSystem.eachNode(function(node, pt){
          // node: {mass:#, p:{x,y}, name:"", data:{}}
          // pt:   {x:#, y:#}  node position in screen coords



          // determine the box size and round off the coords if we'll be
          // drawing a text label (awful alignment jitter otherwise...)
          var w = ctx.measureText(node.data.label||"").width + 6
          var label = node.data.label
          if (!(label||"").match(/^[ \t]*$/)){
            pt.x = Math.floor(pt.x)
            pt.y = Math.floor(pt.y)
          }else{
            label = null
          }


          // clear any edges below the text label
          // ctx.fillStyle = 'rgba(255,255,255,.6)'
          // ctx.fillRect(pt.x-w/2, pt.y-7, w,14)


//           ctx.clearRect(pt.x-w/2, pt.y-7, w,14)



          // draw the text
          if (label){
            ctx.font = "bold "+(node.data.node ? 11 : 9)+"px Arial"
            ctx.textAlign = "center"

            // if (node.data.region) ctx.fillStyle = palette[node.data.region]
            // else ctx.fillStyle = "#888888"
            ctx.fillStyle = node.data.node ? "#000000" : "#888888";

            // ctx.fillText(label||"", pt.x, pt.y+4)
            ctx.fillText(label||"", pt.x, pt.y+4)
          }

        if (node.data.linkcount && node.data.linkcount > 5) {
            ctx.beginPath()
            ctx.strokeStyle = 'rgba(123,0,0,.3)'
            ctx.fillStyle = 'rgba(123,0,0,.1)'
            ctx.arc(pt.x, pt.y, node.data.linkcount*0.1, 0, 2 * Math.PI)
            ctx.fill(); ctx.stroke()
            ctx.closePath()
        }
        })
      },

      resize:function(){
        var w = $(window).width(),
            h = $(window).height();
        canvas.width = w; canvas.height = h // resize the canvas element to fill the screen
        particleSystem.screenSize(w,h) // inform the system so it can map coords for us
        that.redraw()
      },

    	initMouseHandling:function(){
        // no-nonsense drag and drop (thanks springy.js)
      	selected = null;
      	nearest = null;
      	var dragged = null;
        var oldmass = 1

        $(canvas).mousedown(function(e){
      		var pos = $(this).offset();
      		var p = {x:e.pageX-pos.left, y:e.pageY-pos.top}
      		selected = nearest = dragged = particleSystem.nearest(p);

      		if (selected.node !== null){
            dragged.node.tempMass = 50
            dragged.node.fixed = true
      		}
      		return false
      	});

      	$(canvas).mousemove(function(e){
          var old_nearest = nearest && nearest.node._id
      		var pos = $(this).offset();
      		var s = {x:e.pageX-pos.left, y:e.pageY-pos.top};

      		nearest = particleSystem.nearest(s);
          if (!nearest) return

      		if (dragged !== null && dragged.node !== null){
            var p = particleSystem.fromScreen(s)
      			dragged.node.p = {x:p.x, y:p.y}
            // dragged.tempMass = 10000
      		}

          return false
      	});

      	$(window).bind('mouseup',function(e){
          if (dragged===null || dragged.node===undefined) return
          dragged.node.fixed = false
          dragged.node.tempMass = 100
      		dragged = null;
      		selected = null
      		return false
      	});

      },

    }

    return that
  }

  var Maps = function(elt){
    var sys = arbor.ParticleSystem(8000, 500, 0.1, 55)
    sys.renderer = Renderer("#viewport") // our newly created renderer will have its .init() method called shortly by sys...

    var dom = $(elt)
    var _links = dom.find('ul')

    var _sources = {
      am:'<div id="dataset">derived from active memory <a target="_blank" href="http://localhost:5984/_util">admin</a></div>',
    }

    var _maps = {
      cosmos:{title:"Cosmos", p:{stiffness:600}, source:_sources.am},
      city:{title:"City", p:{stiffness:600}, source:_sources.am},
      ufo:{title:"Ufo", p:{stiffness:600}, source:_sources.am},
      life:{title:"Life", p:{stiffness:600}, source:_sources.am},
      mathematics:{title:"Math", p:{stiffness:600}, source:_sources.am},
      physics:{title:"Physics", p:{stiffness:600}, source:_sources.am},
      algebra:{title:"Algebra", p:{stiffness:600}, source:_sources.am},
      calculus:{title:"Calculus", p:{stiffness:600}, source:_sources.am},
//       asia:{title:"Asia", p:{stiffness:500}, source:_sources.am},
//       europe:{title:"Europe", p:{stiffness:300}, source:_sources.am},
//       mideast:{title:"Middle East", p:{stiffness:500}, source:_sources.am},
//       risk:{title:"Risk", p:{stiffness:400}, source:_sources.am}
    }

    var that = {
      init:function(){

        $.each(_maps, function(stub, map){
          _links.append("<li><a href='#/"+stub+"' class='"+stub+"'>"+map.title+"</a></li>")
        })
        _links.append("<li><input type='text' placeholder='query …'></li>")
        _links.find('li > input').keypress(that.addQuery)
        _links.find('li > a').click(that.mapClick)
        _links.find('.cosmos').click()
        return that
      },
      addQuery:function(e){
        if ((e.keyCode || e.which) != 13) return;
        var input = $(e.target)
        var newMap = input.val(); input.val("");
        if (!(newMap in _maps)) {
            _maps[newMap] = {
                title:newMap,
                p:{stiffness:600},
                source:_sources.am,
            };
            _links.append("<li><a href='#/"+newMap+"' class='"+newMap+"'>"+newMap+"</a></li>")
            _links.find('li > .'+newMap).click(that.mapClick)
        }
        _links.find('li > .'+newMap).click()
        return false
      },
      mapClick:function(e){
        var selected = $(e.target)
        var newMap = selected.attr('class')
        if (newMap in _maps) that.selectMap(newMap)
        _links.find('li > a').removeClass('active')
        selected.addClass('active')
        return false
      },
      selectMap:function(map_id){
        var url = "http://localhost:5984/table/_design/base/_view/articles?"
            + "start_key=[%22"+map_id+"%22]&"
            + "end_key=[%22"+map_id+"ZZ%22]&"
            + "reduce=false&limit="+LIMIT.node;
        $.getJSON(url,function(data){
//         $.getJSON("maps/"+map_id+".json",function(data){
            var nodes = {};
            var edges = {};
            console.log("got data");
            data.rows.forEach(function (row) {
                var relations = {};
                row.value[1].node = true;
                row.value[1].label  = row.value[0];
                nodes[row.value[0]] = row.value[1];
                edges[row.value[0]] = relations;
                var related =  row.value[3].related;
                var len = Math.min(LIMIT.rel, related.length);
                for (var rel, i = 0 ; i < len ; i++) {
                    rel = related[i];
                    if (!nodes[rel]) nodes[rel] = {label:rel};
                    relations[rel] = {};
                };
            });
            var keys = Object.keys(nodes);
            var counter = keys.length;
            console.log("current nodes", nodes, counter)
            keys.forEach(function (node_id) {
                var url = "http://localhost:5984/table/_design/base/_view/linkcount?"
                    + "start_key=%22"+node_id+"%22&"
                    + "group=true&limit=1";
                $.getJSON(url,function(data){
                    if (data.rows[0])
                        nodes[node_id].linkcount = data.rows[0].value;
                    if (--counter == 0) {
                            console.log("done", nodes, edges);
//                         load the raw data into the particle system as is (since it's already formatted correctly for .merge)
// //                         var nodes = data.nodes
//                         $.each(nodes, function(name, info){
//                             info.label=name.replace(/(people's )?republic of /i,'').replace(/ and /g,' & ')
//                         })

                        sys.merge({nodes:nodes, edges:edges})
//                         sys.merge({nodes:{}, edges:{}})
                        sys.parameters(_maps[map_id].p)

                    }
                });
            });
          $("#dataset").html(_maps[map_id].source)
        })

      }
    }

    return that.init()
  }




  $(document).ready(function(){

    var mcp = Maps("#maps")

  })








})()