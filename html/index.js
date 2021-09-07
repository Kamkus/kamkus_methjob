
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    function display1(bool1) {
        if (bool1) {
            $("#progressbar").fadeIn();
        } else {
            $("#progressbar").hide();
        }
    }
    $("#progressbar1").hide();
    display1(false)
    display(false)

    var expectedAnswer;
    var object;
    window.addEventListener('message', function(event) {
       var item = event.data;
        if (item.type === "ui") {
            expectedAnswer = item.answer
            object = item.object
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }

        }

        if (item.type === "bar") {
            if (item.status == true) {
                display1(true)
                $('#bar_text').text(item.word);
                $('#bar_div').css("width", item.percentage + "%");
                setTimeout(function(){ $("#progressbar").fadeOut(); }, 3000)
            } else {
                display1(false)
            }
        }


        if (item.type === "progress") {
            if (item.display === true) {
            $("#progressbar1").show();
                var start = new Date();
                var timeoutVal = Math.floor(item.time/100);
                var maxTime = item.time;
                $('#bar_text1').text(item.text);
                animateUpdate();


                function updateProgress(percentage) {
                    $('#bar_div1').css("width", percentage + "%");
                }

                function animateUpdate() {
                    var now = new Date();
                    var timeDiff = now.getTime() - start.getTime();
                    var perc = Math.round((timeDiff/maxTime)*100);
                    console.log(perc);
                    if (perc <= 100) {
                        updateProgress(perc);
                        setTimeout(animateUpdate, timeoutVal);
                    } else {
                        $("#progressbar1").hide();
                    }
                }
 
            } else {
                $("#progressbar1").hide();
            }
        }

        if (item.type === "notify") {
            $.notify(item.message, {position: "top left", className: item.option});
        }

    })


    $("button").click(function() {
        var fired_button = $(this).val();
        if(expectedAnswer !== undefined){
            if(expectedAnswer == fired_button){
        $.post('http://kamkus_methjob/success', JSON.stringify({
            object: object
    }));

        console.log("Success")
        } else {
            $.post('http://kamkus_methjob/error', JSON.stringify({
                
                object: object
    }));
    console.log("ejoj")
        }
    }
    })
