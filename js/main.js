function clickCarousel(url){
	window.location.href = url;
}

function openModal(id){
	id = '#' + id;
	$('.modal').removeClass('is-active');
	$(id).addClass('is-active');
}
function closeModal(id){
	id = '#' + id;
	$(id).removeClass('is-active');
}

function toggleNavMenu(){
	var isactive =  $('#burger').hasClass('is-active');
	if (isactive) {
		$('#burger').removeClass('is-active');
		$('#menu').removeClass('is-active');
	} else {
		$('#burger').addClass('is-active');
		$('#menu').addClass('is-active');
	}
};
