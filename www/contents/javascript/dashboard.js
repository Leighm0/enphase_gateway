document.addEventListener("DOMContentLoaded", function(){
	C4.subscribeToDataToUi(true);
});

function updateData(variable, value) {
	console.log("updateData: " + variable + value)
	document.getElementById(variable).textContent=value;
}

function onDataToUi(value) {
	console.log("DATA_TO_UI: " + value);
	var response = JSON.parse(value);
	if (!response || typeof response !== "object") {
		console.log("DATA_TO_UI: onDataToUi called with invalid or no JSON");
		return;
	}
	console.log("DATA_TO_UI: successfully parsed response.");
	var data = response.data;
	console.log(data);
	for (var property in data) {
		if (data.hasOwnProperty(property)) {
			console.log(data[property]);
			updateData(property, data[property]);
		}
	}
}

function onSubscribeToDataToUi(message) {
	alert("Error subscribing to data to ui: " + message);
}
