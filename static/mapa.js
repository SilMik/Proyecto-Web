//arreglo de prueba
var iCompañia = [-39.808759,-73.256989,-39.813705,-73.222247,-39.820530,-73.229923,-39.816869,-73.238551,-39.812147,-73.244991,-39.832151,-73.216759,-39.831917,-73.241785,-39.812155,-73.244992,-39.814643,-73.209233,-39.869958,-73.400171]; 



function initMap(){
  //iniciamos mapa en elemento con id map
   /* $(document).ready(function(){
      var a=document.getElementById('codigo').innerHTML.replace("Código: ","");
      alert(a);
    });*/
      var map = new google.maps.Map($('#map').get(0), {
        center: new google.maps.LatLng(-39.834437, -73.235366),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        scrollwheel: true,
        zoom: 15,
        zoomControl: true,
        scaleControl: true
      });//end ap
      var directionsDisplay = new google.maps.DirectionsRenderer({
        map: map
      });
      //esta funcion debemos buscar donde se ejecute mejor!
   emergencia();
  };//end initMap



  /* Georeferenciación */
function emergencia(){
      $(document).ready(function(){
    
       //obtenemos las calles limpiando el contenido que no necesitamos 
      var sCalle1=document.getElementById('calle1').innerHTML.replace("Calle Principal: ","");
      var sCalle2=document.getElementById('calle2').innerHTML.replace("Calle/Esquina: ","");
      //creamos la direccion address
      var address = sCalle1+", Region de los Rios"+" & "+sCalle2+", Region de los Rios";
     
      // Creamos el Objeto Geocoder
      var geocoder = new google.maps.Geocoder();
     
      
      // Hacemos la petición indicando la dirección e invocamos la función
      // geocodeResult enviando todo el resultado obtenido
      geocoder.geocode({ 'address': address}, geocodeResult);

      //Testeo funcion distancias
      distancia(iCompañia, address); 
       
      
  });
      
  
}

  /*Funcion para procesar la georeferenciacion y generar el marcador*/
  function geocodeResult(results, status) {
    // Verificamos el estatus
    if (status == 'OK') {
        // Si hay resultados encontrados, centramos y repintamos el mapa
        // esto para eliminar cualquier pin antes puesto
        var mapOptions = {
            center: results[0].geometry.location,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map($('#map').get(0), mapOptions);
        // fitBounds acercará el mapa con el zoom adecuado de acuerdo a lo buscado
        map.fitBounds(results[0].geometry.viewport);
        // Dibujamos un marcador con la ubicación del primer resultado obtenido
        var markerOptions = { position: results[0].geometry.location }
        var marker = new google.maps.Marker(markerOptions);
        marker.setMap(map);
    } else {
        // En caso de no haber resultados o que haya ocurrido un error
        // lanzamos un mensaje con el error
        alert("Geocoding no tuvo éxito debido a: " + status);
    }
}

function distancia(origenes,destino){
 //origen, en este caso sera la lat, lng de las compañias!
  var sOrigen = {lat: iCompañia[0], lng: iCompañia[1]};
  var sOrigen2= {lat: iCompañia[2], lng: iCompañia[3]};
  var sOrigen3= {lat: iCompañia[4], lng: iCompañia[5]};
  var sOrigen4= {lat: iCompañia[6], lng: iCompañia[7]};
  var sOrigen5= {lat: iCompañia[8], lng: iCompañia[9]};
  var sOrigen6= {lat: iCompañia[10], lng: iCompañia[11]};
  var sOrigen7= {lat: iCompañia[12], lng: iCompañia[13]};
  var sOrigen8= {lat: iCompañia[14], lng: iCompañia[15]};
  var sOrigen9= {lat: iCompañia[16], lng: iCompañia[17]};
  var sOrigen10= {lat: iCompañia[18], lng: iCompañia[19]};
 //Destino sera el lugar de la emergencia! cale1+calle2
  var sDestino = destino;
  //Llamamos al servicio de Matrix Distance Service
  var service = new google.maps.DistanceMatrixService;
  service.getDistanceMatrix({
    origins: [sOrigen, sOrigen2, sOrigen3,sOrigen4,sOrigen5,sOrigen6,sOrigen7,sOrigen8,sOrigen9,sOrigen10],
    destinations: [sDestino],
    travelMode: google.maps.TravelMode.DRIVING,
    unitSystem: google.maps.UnitSystem.METRIC,
    avoidHighways: false,
    avoidTolls: false
  },function(response, status) {
    if (status !== google.maps.DistanceMatrixStatus.OK) {
      alert('Error was: ' + status);
    } else {
      var originList = response.originAddresses;
      var destinationList = response.destinationAddresses;
      //var outputDiv = document.getElementById('output');
      var sDistancia = [];
      //Aca tomamos las distancias y las ordenamos
      /**/
      for (var i = 0; i < originList.length; i++) {
        var results = response.rows[i].elements;
        for (var j = 0; j < results.length; j++) {
          sDistancia.push(results[j].distance.value);
        }
      }
      //sDistancia.sort();
      //Metros!
      var iMin= Math.min.apply(null,sDistancia);
     // document.getElementById('dist').value=iMin;
      //le compañia!
      var iMinCompañia=(sDistancia.indexOf(Math.min.apply(null,sDistancia))+1);
      document.getElementById('comp').value=iMinCompañia;
      //le compañia!


    }
  });


}



