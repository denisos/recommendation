<!doctype html>
<!--[if lt IE 7]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"> <!--<![endif]-->
<head>
	<meta charset="utf-8">
    <title>Recommendations Page</title>
	
	<link type="text/css" href="css/rec.css" rel="stylesheet" />
	
</head>
<body>
	<h1>Recommendations lookup</h1>
	<div id="rec_left_side">
		<h2>Enter search criteria</h2>
		<ul class="nb">
			<li>
				<label for="email">Email:</label>
				<input type="text" name="email" maxlength="254" id="email" placeholder="Enter email"/>
			</li>
				<label for="date">Date:</label>
				<input type="text" name="date" maxlength="10" id="date" value="2011-11-11" /> 
			</li>

			<li><button id="get_recs">Get Recommendations</button></li>
		</ul>
		<p>I found that supersize@subrational.com went to 1 event which was dated 2011-11-10. Not 
 the Nov 1st date in the Instructions. So if you search for that user then please enter 2011-11-11 in
 search criteria. The results will be for any recommendations after the date entered.</p>
		<p>Recommendations are only for events after the date entered, i.e. future events.</p>
	</div>
	
	<div id="rec_right_side">
		<h2>Your Recommendations. Number Found: <span id="found_count"></span></h2>
		<h2 id="no_matches">Sorry, no recommendations found, please search again</h2>
		
		<ul id="events" class="nb">
		</ul>
	</div>
		
	<!--
	<script src="js/vendor/modernizr-1.6.min.js"></script>
	-->		
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
	<script type="text/javascript">
		$('#get_recs').click(function() {
			var params;
			
			// clear prev results
			$('#no_matches').hide();
			$('#found_count').empty();
			$('#events').empty();
			
			// assemble the url params, would encode for real app, serialize a form is another option
			params = 'email='+$('#email').val();
			params += '&date='+$('#date').val();
			
			$.ajax({  
			  type: 'GET',  
			  url: 'getRec.php',         
			  data: params,  
			  success: function(data) {  
				var i;
				for (i = 0; i < data.length; i++) {
					$('#events').append('<li>' + data[i] + '</li>');
				}
				
				$('#found_count').text(data.length);  
				
				}, 
			  error: function(xhr, textStatus, errorThrown) {  
				$('#no_matches').show();  
				$('#found_count').text('0');
				}  				
			  });  
		});		
	</script>		
</body>
</html>