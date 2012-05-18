int WIDTH = 1200;
int HEIGHT = 800;

int lastMouseX = 0;
int lastMouseY = 0;
int x_rotation = 0;
int y_rotation = 0;

PFont font;
Graph _graph;

JavaScript js;

interface JavaScript {
	void displaySelectedNodeInfo(String name, float flow);	
}

void bindJavascript(JavaScript jscript) {
	js = jscript;
}


void setup() {
	size(WIDTH, HEIGHT, P3D);
	font = createFont("Arial", 10);
	sphereDetail(15);
	_graph = genCanadaSankeyGraph(); 
}

Graph genCanadaSankeyGraph() {
	Graph g = new Graph();
	String[] srcNames = {"Uranium", "Hydro", "Natural Gas", "Biomass", "Coal", "Petroleum"};
	String[] dstNames = {"Residential", "Industrial", "Transportation", "Non-fuel", "Export"};
	Node n;
	for(int i=0; i < srcNames.length; i++) {
		n = new Node(i+1, srcNames[i],0);
		g.addNode(n);
	}
	for(int i=0; i < dstNames.length; i++) {
		n = new Node((i+1)*10, dstNames[i],3);
		g.addNode(n);
	}

	n = new Node(100, "Electric Power", 1);
	g.addNode(n);
	n = new Node(101, "Distributed Electricity", 2);
	g.addNode(n);
	
	g.addArc(100,101,2.0);	// elec to dist
	g.addArc(101,10,1.02); 	// dist res
	g.addArc(101,20,0.86);	// dist indus


	g.addArc(1,50,7.61);		// uranium to export
	g.addArc(1,100,0.81);	// uranium to elec
	g.addArc(2,100,1.2);		// hydro to elec
	g.addArc(3,100,0.34);	// nat gas to elec
	g.addArc(3,50,4.15);		// nat gas to export
	g.addArc(3,10,1.25);		// ng res
	g.addArc(3,20,1.72);		// ng indus
	g.addArc(3,30,0.01);		// ng trans
	g.addArc(3,40,0.43);		// ng nonfuel
	g.addArc(4,10,0.11);		// bio res
	g.addArc(4,20,0.5);		// bio indus
	g.addArc(4,100,0.8);		// bio elec
	g.addArc(5,100,1.16);	// coal elec
	g.addArc(5,20,0.18);		// coal indus
	g.addArc(5,50,0.74);		// coal export
	g.addArc(6,100,0.14);	// petrol elec
	g.addArc(6,10,0.26);		// petrol res	
	g.addArc(6,20,0.88);		// petrol ind
	g.addArc(6,30,2.34);		// petrol trans
	g.addArc(6,40,0.47);		// petrol nonfuel
	g.addArc(6,50,4.45);		// petrol export
	return g;
}
/*
Graph genRandomGraph() {
	Graph graph = new Graph();
	int numSource = int(random(1,5));
	int numSink = int(random(1,5));
	for(int i = 0; i < numSink; i++) {
		Node dst = new Node((i+1)*10, "fdsa");
		graph.addSink(dst);
	}
	for(int j = 0; j < numSource; j++) {
		Node src = new Node(j+1, "asdf");
		graph.addSource(src);
	}
	for(int i = 0; i < numSource; i++) {
		for(int j = 0; j < numSink; j++) {
			// add some random edges
			int rnd = int(random(0,1000));
			if(rnd<500)
				graph.addArc(i+1,(j+1)*10,rnd%20+5);
		}
	}
	return graph;
}
*/
void draw() {
	lights();
	background(150);

	float cameraY = HEIGHT/2.0;
	float fov = PI/3.0;
	float cameraZ = cameraY / tan(fov / 2.0);
	float aspect = float(WIDTH)/float(HEIGHT);
	perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);
	translate(WIDTH/2, HEIGHT/2, 0);

	rotateX(x_rotation * PI/500);
	rotateY(y_rotation * PI/500);
	
	_graph.draw(WIDTH, HEIGHT);
}

void mousePressed() {
	setLastMouse();
}

void setLastMouse() {
	lastMouseX = mouseX;
	lastMouseY = mouseY;
}

float dragLength() {
	return sqrt( pow(mouseX-lastMouseX,2) + pow(mouseY-lastMouseY,2) );
}

void mouseDragged() {
	if(dragLength() > 10)
		setLastMouse();
	y_rotation += (mouseX-lastMouseX);
	x_rotation += (lastMouseY-mouseY);
}

void updateArcRate(int arcIndex, float rate) {
	if(null != _graph)
		_graph.updateArcRate(arcIndex, rate);
}

void updateArcFlow(int arcIndex, float multiplier){
	if(null != _graph)
		_graph.updateArcFlow(arcIndex, multiplier);
}

void keyPressed() {
	if(key == 'r' || key == 'R')
		resetRotation();
}

void resetRotation() {
	x_rotation = 0;
	y_rotation = 0;
}
