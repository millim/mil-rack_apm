var method = '';
var path = '';
var min_count = 0;
var max_count = 0;

$(document).ready(function(){
    
    $('#path').keyup(function() {
        if(path != $(this).val()){
            path = $(this).val()
            update_data();
        }
    });

    $('#min_count').keyup(function() {
        var num = parseInt($(this).val());
        if(min_count != num){
            min_count = num;
            update_data();
        }
    });

    $('#max_count').keyup(function() {
        var num = parseInt($(this).val());
        if(max_count != num){
            max_count = num;
            update_data();
        }
    });

    $("#method").change(function(){
        if(method != $(this).val()){
            method = $(this).val()
            update_data();
        }
    });

    $('.delete_key').click(function(){
        if(confirm("Are you delete the key?")){
            var url = window.location.href.split('?')[0];
            var obj = $(this);
            $.ajax({
                method: "DELETE",
                url:  url +"/delete_key",
                data: { key: obj.attr('key') },
                success: function(message){
                    if('ok' == message){
                        obj.parents('tr').remove();
                    }else{
                        alert('delete error!');
                    }
                }
            })
        }
    })

    $('.delete_show').click(function(){
        if(confirm("Are you delete all show key?")){
            delete_all_show();
        }
    })

})

var delete_all_show = function(){
    $("#table_data tr").each(function(){
        if ($(this).attr("class").indexOf("no_data") < 0){
            if ($(this).attr("style").indexOf("display: none;") < 0){
                var url = window.location.href.split('?')[0];
                var obj = $(this).find(".delete_key");
                $.ajax({
                    method: "DELETE",
                    url:  url +"/delete_key",
                    data: { key: obj.attr('key') },
                    success: function(message){
                        if('ok' == message){
                            obj.parents('tr').remove();
                        }else{
                            alert('delete error!');
                        }
                    }
                })
            }
        };
    });

}

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

            if(min_count > 0){
                var pathInt =parseInt($(this).find(".count").text());
                if (pathInt < min_count) {
                    is_show = false;
                }
            }

            if(max_count > 0){
                var pathInt =parseInt($(this).find(".count").text());
                if (pathInt > max_count) {
                    is_show = false;
                }
            }

            show_controller($(this), is_show);
        }
    });
};

var show_controller = function(obj, is_show){
    if(is_show){
        obj.show('slow');
    }else{
        obj.hide('slow');
    }

}