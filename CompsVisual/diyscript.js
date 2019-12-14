
/*
Copyright 2010-2017 Mike Bostock
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author nor the names of contributors may be used to
  endorse or promote products derived from this software without specific prior
  written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/
(function() {
	var width = 500,
	height = 500;
	
	var svg = d3.select("#chart")
		.append("svg")
		.attr("height", height)
		.attr("width", width)
		.append("g")
		.attr("transform", "translate(0,0)")

	var defs = svg.append("defs");

	defs.append()

	var radiusScale = d3.scaleSqrt().domain([0,320]).range([10,80])

	var simulation = d3.forceSimulation()
		.force("x", d3.forceX(width/ 2).strength(0.05))
		.force("y", d3.forceY(height/ 2).strength(0.05))
		.force("collide", d3.forceCollide(function(d) {
			return radiusScale(d.frequency) + 1;
		}));	// adjust these #'s
	d3.queue()
	.defer(d3.csv, "local.csv")
	.await(ready)


	function ready (error, datapoints) {

		var circles = svg.selectAll(".artist")  // !!!	
			.data(datapoints)
			.enter().append("circle")
			.attr("class", "artist")
			.attr("r", function(d) {
				return radiusScale(d.frequency)
			}) // !!
.style("fill", function(d) { return d3.rgb(d.fill); })
			simulation.nodes(datapoints)
			.on('tick', ticked)
	  
		function ticked(){
				circles
					.attr("cx", function(d) {
						return d.x
					})
					.attr("cy", function(d) {
						return d.y
					})
			}
	}	








	})();
