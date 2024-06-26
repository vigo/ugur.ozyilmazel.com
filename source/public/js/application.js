$(document).ready(function(){
    $("p img.clipart").parent().addClass("clipart");
    
    $(".full img").on("click", function() {
        $(this).toggleClass("zoom");
    });

    let qs_params = new Proxy(new URLSearchParams(window.location.search), {
      get: (searchParams, prop) => searchParams.get(prop),
    });

    if(qs_params.p){
        let url = $("section.section.menu a.is-active")[0].href;
        let pageKey = window.location.pathname.indexOf('tr') > -1 ? "sayfa" : "page";
        $("section.section.menu a.is-active")[0].href = `${url}${pageKey}/${qs_params.p}/`;
    }

    $("span.player-status").on("click", function(){
        $img = $(this).next('img.animate');
        let source = $img.attr("src");
        let target = $img.data("play");

        if (source.split('.').pop().split(/\#|\?/)[0] === "png") {
            $(this).text("⏸");
        } else {
            $(this).text("▶");
        }
        
        $img.attr("src", target);
        $img.data("play", source);
    });

});
