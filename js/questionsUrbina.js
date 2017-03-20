var formElement=null;
var numeroSecreto=null;
var respuestaSelect=null;
var respuestasCheckbox = [];
var nota = 0.0;  //nota de la prueba sobre 3 puntos (hay 3 preguntas)
var xmlDoc = null; //global, para modificarlo y serializarlo (y sacarlo por pantalla)
var xslDoc = null;

//**************************************************************************************************** 
//Después de cargar la página (onload) se definen los eventos sobre los elementos entre otras acciones.
window.onload = function(){ 

 //CORREGIR al apretar el botón
 formElement=document.getElementById('myform');
 formElement.onsubmit=function(){
   if (comprobar()){
    corregirNumber();
    corregirSelect();
    corregirCheckbox();
    presentarNota();
   }
   return false;
 }
 //LEER XML de xml/questions.xml
 var xhttp = new XMLHttpRequest();
 xhttp.onreadystatechange = function() {
  if (this.readyState == 4 && this.status == 200) {
   gestionarXml(this);
  }
 };
 xhttp.open("GET", "xml/questions.xml", true);
 xhttp.send();
 
  //LEER XSL de xml/questions.xml
 var xhttp2 = new XMLHttpRequest();
 xhttp2.onreadystatechange = function() {
  if (this.readyState == 4 && this.status == 200) {
   xslDoc=this.responseXML;
  }
 };
 xhttp2.open("GET", "xml/questions.xsl", true);
 xhttp2.send();
 
}


//****************************************************************************************************
// Recuperamos los datos del fichero XML xml/preguntas.xml
// xmlDOC es el documento leido XML. 
function gestionarXml(dadesXml){
 xmlDoc = dadesXml.responseXML; //Parse XML to xmlDoc

 //NUMBER
 //Recuperamos el título y la respuesta correcta de Input, guardamos el número secreto
 var tituloInput=xmlDoc.getElementsByTagName("title")[0].innerHTML;
 ponerDatosInputHtml(tituloInput);
 numeroSecreto=parseInt(xmlDoc.getElementsByTagName("answer")[0].innerHTML);
 
 //SELECT
 //Recuperamos el título y las opciones (que están dentro de los nodos seleccionados con Xpath: nodesSelect) 
 var tituloSelect=xmlDoc.getElementsByTagName("title")[1].innerHTML;
 var xpath="/questions/question[@id='profe_002']/option";
 var nodesSelect = xmlDoc.evaluate(xpath, xmlDoc, null, XPathResult.ANY_TYPE, null);
 ponerDatosSelectHtml(tituloSelect,nodesSelect);
 //guardamos la respuesta correcta
 respuestaSelect=parseInt(xmlDoc.getElementsByTagName("answer")[1].innerHTML);

 //CHECKBOX
 //Recuperamos el título y las opciones (que están dentro de los nodos seleccionados con Xpath: nodesSelect)
 var tituloCheckbox = xmlDoc.getElementsByTagName("title")[2].innerHTML;
 var xpath="/questions/question[@id='profe_003']/option";
 var nodesCheckbox = xmlDoc.evaluate(xpath, xmlDoc, null, XPathResult.ANY_TYPE, null); 
 ponerDatosCheckboxHtml(tituloCheckbox,nodesCheckbox);
 //guardamos las respuestas correctas
 var nres = xmlDoc.getElementById("profe_003").getElementsByTagName('answer').length;
 for (i = 0; i < nres; i++) { 
  respuestasCheckbox[i]=xmlDoc.getElementById("profe_003").getElementsByTagName("answer")[i].innerHTML;
 }
}

//****************************************************************************************************
//implementación de la corrección

function corregirNumber(){
  //Ponemos lo que hemos puesto como elemento añadido al documento xml (appendChild)
  var s=formElement.elements[0].value;     
  if (s==numeroSecreto) {
   nota +=1;
  }
  var useranswer = xmlDoc.createElement("useranswer");   
  useranswer.innerHTML = s;
  xmlDoc.getElementById("profe_001").appendChild(useranswer);
}

function corregirSelect(){
  //Compara el índice seleccionado con el valor del íncide que hay en el xml (<answer>2</answer>)
  //para implementarlo con type radio, usar value para enumerar las opciones <input type='radio' value='1'>...
  //luego comparar ese value con el value guardado en answer
  var sel = formElement.elements[1];  
  if (sel.selectedIndex-1==respuestaSelect) { //-1 porque hemos puesto una opción por defecto en el select que ocupa la posición 0
   nota +=1;
  }
  var useranswer = xmlDoc.createElement("useranswer");   
  useranswer.innerHTML = sel.selectedIndex;
  xmlDoc.getElementById("profe_002").appendChild(useranswer);
}

//Si necesitáis ayuda para hacer un corregirRadio() decirlo, lo ideal es que a podáis construirla modificando corregirCheckbox
function corregirCheckbox(){
  //Para cada opción mira si está checkeada, si está checkeada mira si es correcta y lo guarda en un array escorrecta[]
  var f=formElement;
  var escorrecta = [];
  for (i = 0; i < f.color.length; i++) {  //"color" es el nombre asignado a todos los checkbox
   if (f.color[i].checked) {
    var useranswer = xmlDoc.createElement("useranswer");   
    useranswer.innerHTML = i+1;
    xmlDoc.getElementById("profe_003").appendChild(useranswer);
    escorrecta[i]=false;     
    for (j = 0; j < respuestasCheckbox.length; j++) {
     if (i==respuestasCheckbox[j]) escorrecta[i]=true;
    }
    //si es correcta sumamos y ponemos mensaje, si no es correcta restamos y ponemos mensaje.
    if (escorrecta[i]) {
     nota +=1.0/respuestasCheckbox.length;  //dividido por el número de respuestas correctas   
    } else {
     nota -=1.0/respuestasCheckbox.length;  //dividido por el número de respuestas correctas   
    }   
   } 
  }
}

//****************************************************************************************************
// poner los datos recibios en el HTML
function ponerDatosInputHtml(t){
 document.getElementById("tituloInput").innerHTML = t;
}

function ponerDatosSelectHtml(t,nodes){
  document.getElementById("tituloSelect").innerHTML=t;
  var select = document.getElementsByTagName("select")[0];
  var result = nodes.iterateNext();
  i=0;
  while (result) {
   var option = document.createElement("option");
   option.text = result.innerHTML;
   option.value=i+1; i++;
   select.options.add(option);
   result = nodes.iterateNext();
  }  
}

function ponerDatosCheckboxHtml(t,nodes){
 var checkboxContainer=document.getElementById('checkboxDiv');
 document.getElementById('tituloCheckbox').innerHTML = t;
  var result = nodes.iterateNext();
  i=0;
  while (result) {
   var input = document.createElement("input");
   var label = document.createElement("label");   
   label.innerHTML = result.innerHTML
   label.setAttribute("for", "color_"+i);
   input.type="checkbox";
   input.name="color";
   input.id="color_"+i; i++;
   checkboxContainer.appendChild(input);
   checkboxContainer.appendChild(label);
   checkboxContainer.appendChild(document.createElement("br"));
   result = nodes.iterateNext();
  }    
}

//****************************************************************************************************
//Gestionar la presentación de las respuestas
function darRespuestaHtml(r){
 var p = document.createElement("p");
 var node = document.createTextNode(r);
 p.appendChild(node);
 document.getElementById('resultadosDiv').appendChild(p);
}

function presentarNota(){   
   document.getElementById('resultadosDiv').style.display = "block";
   //Código transformación xslt con xmlDoc y xslDoc
   if (document.implementation && document.implementation.createDocument) {
        xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(xslDoc);
        resultDocument = xsltProcessor.transformToFragment(xmlDoc, document);
        document.getElementById('resultadosDiv').appendChild(resultDocument);
   }
   darRespuestaHtml("Nota: "+nota+" puntos sobre 3");
   //bloquear formulario (recargar para volver a empezar)
   var f=formElement;
   var e = f.elements;
   for (var i = 0, len = e.length; i < len; ++i) {
    e[i].disabled = true;
   }
}

//Comprobar que se han introducido datos en el formulario
function comprobar(){
   var f=formElement;
   var checked=false;
   for (i = 0; i < f.color.length; i++) {  //"color" es el nombre asignado a todos los checkbox
      if (f.color[i].checked) checked=true;
   }
   if (f.elements[0].value=="") {
    //recomendamos focus para input y select "normal", scrollIntoView para el título de select múltiple, radio y checkbox
    f.elements[0].focus(); 
    alert("Escribe un número");
    return false;
   } else if (f.elements[1].selectedIndex==0) {
    f.elements[1].focus();
    alert("Selecciona una opción");
    return false;
   } if (!checked) {    
    document.getElementsByTagName("h3")[2].scrollIntoView();
    alert("Selecciona una opción del checkbox");
    return false;
   } else  return true;
}