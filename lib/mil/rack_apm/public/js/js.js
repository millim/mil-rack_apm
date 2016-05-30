var method = '';
var path = '';
var count = 0;

$(document).ready(function(){
    
    // $("#table_data tr").bind('click', function(){
    //     update_data();
    // })


    $('#path').keyup(function() {
        if(path != $(this).val()){
            path = $(this).val()
            update_data();
        }
    });

    $('#min_count').keyup(function() {
        var num = parseInt($(this).val());
        if(count != num){
            count = num;
            update_data();
        }
    });

    $("#method").change(function(){
        if(method != $(this).val()){
            method = $(this).val()
            update_data();
        }
    });

})

var update_data = function(){
    $("#table_data tr").each(function(){
        if ($(this).attr("class").indexOf("no_data") < 0){
            var is_show = true;
            if(path != ''){
                var pathString =$(this).find(".path").text();
                // alert(pathString.indexOf(path));
                if (pathString.indexOf(path) < 0) {
                    is_show = false;
                }

            }

            if(method != ''){
                var pathString =$(this).find(".request_method").text();
                if (pathString != method) {
                    is_show = false;
                }
            }

            if(count > 0){
                var pathInt =parseInt($(this).find(".count").text());
                if (pathInt < count) {
                    is_show = false;
                }
            }

            show_controller($(this), is_show);
        }
        // if(objString.length>46){
        //     objString=$(this).children("#Emailtd").text(objString.substring(0,46) + "...")
        // }
    });
};

var show_controller = function(obj, is_show){
    if(is_show){
        obj.show('slow');
    }else{
        obj.hide('slow');
    }

}