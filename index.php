<?php          
	if(isset($_POST['dataSubmit'])){
		$name = $_POST['name'];
		$age = $_POST['age'];
		$year = $_POST['year'];
		$branch = $_POST['branch'];
		$gpa = $_POST['gpa'];
		$credits = $_POST['credits'];
		$fieldInterest = $_POST['fieldInterest'];
		$creditsInterest = $_POST['creditsInterest'];
		$experience = $_POST['experience'];
		$internshipYear = $_POST['internshipYear'];
		$fieldInternship = $_POST['fieldInternship'];  
		$fieldPlacement = $_POST['fieldPlacement'];
		$package = $_POST['package'];
		$familyBusiness = $_POST['familyBusiness'];
		$familyIncome = $_POST['familyIncome'];

		$fp = fopen('data.txt', 'w');
		fwrite($fp, "'".$name."'.\n");
		fwrite($fp, "'".$age."'.\n");
		fwrite($fp, "'".$year."'.\n");
		fwrite($fp, "'".$branch."'.\n");
		fwrite($fp, "'".$gpa."'.\n");
		fwrite($fp, "'".$credits."'.\n");
		fwrite($fp, "'".$fieldInterest."'.\n");
		fwrite($fp, "'".$creditsInterest."'.\n");
		fwrite($fp, "'".$experience."'.\n");
		fwrite($fp, "'".$internshipYear."'.\n");
		fwrite($fp, "'".$fieldInternship."'.\n");
		fwrite($fp, "'".$fieldPlacement."'.\n");
		fwrite($fp, "'".$package."'.\n");
		fwrite($fp, "'".$familyBusiness."'.\n");
		fwrite($fp, "'".$familyIncome."'.\n");
		fclose($fp);
	}
?>

<html>

<head>
<link href="https://fonts.googleapis.com/css?family=Montserrat:100,200,300,400,500,600,700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Dancing+Script&display=swap" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="style.css">	
<title>
Input Form
</title>
</head>

<body>
<center>
<h1>Career Advising AI System for IIITD</h1><p><br>
<form id="nameform" method="post">
	<h3><div class="a">

	<h4>GENERAL</h4>
	Name<br>
	<input type="text" name="name"><p>
	Age<br>
	<input type="number" name="age" value="20"><p>
	Graduating year<br>
	<select name="year">
	<option value="2020">2020</option>
	<option value="2021">2021</option>
	</select><p>
	Branch<br>
	<select name="branch">
	<option value="CSAI">CSAI</option>
	<option value="CSE">CSE</option>
	<option value="CSAM">CSAM</option>
	<option value="CSD">CSD</option>
	<option value="CSB">CSB</option>
	<option value="ECE">ECE</option>	
	</select><p>
	Average GPA<br>
	<input name="gpa"><p>
	Credits completed<br>
	<input type="number" name="credits" value="156"><p><br>

	<h4>WORK/INTERNSHIP</h4>
	Field of Interest<br>
	<select name="fieldInterest">
	<option value="AIEngineer">AI Engineer</option>
	<option value="SoftwareDevelopment">Software Developer</option>
	<option value="GraphicDesigning">Graphic Designing</option>
	<option value="WebDeveloper">Web Developer</option>
	<option value="SecurityAnalyst">Security Analyst</option>
	<option value="HardwareEngineer">Hardware Engineer</option>
	<option value="Finance">Finance</option>
	<option value="NotPlaced">Not Placed</option>
	</select><p>
	Credits completed in field of Interest<br>
	<h5>(In Core & Open electives)</h5>
	<input type="number" name="creditsInterest"><p>
	Experience (months)<br>
	<input type="number" name="experience"><p>
	Year of latest work/internship<br>
	<input type="number" name="internshipYear" value="2019"><p>
	Field of latest work/internship<br>
	<select name="fieldInternship">
	<option value="AIEngineer">AI Engineer</option>
	<option value="SoftwareDevelopment">Software Developer</option>
	<option value="GraphicDesigning">Graphic Designing</option>
	<option value="WebDeveloper">Web Developer</option>
	<option value="SecurityAnalyst">Security Analyst</option>
	<option value="HardwareEngineer">HardwareEngineer</option>
	<option value="Research">Research</option>
	<option value="Finance">Finance</option>
	</select><p><br>

	<h4>PLACEMENT</h4>
	Field of Placement<br>
	<select name="fieldPlacement">
	<option value="AIEngineer">AI Engineer</option>
	<option value="SoftwareDevelopment">Software Developer</option>
	<option value="GraphicDesigning">Graphic Designing</option>
	<option value="WebDeveloper">Web Developer</option>
	<option value="SecurityAnalyst">Security Analyst</option>
	<option value="HardwareEngineer">Hardware Engineer</option>
	<option value="Finance">Finance</option>
	<option value="NotPlaced">Not Placed</option>
	</select><p>
	Package(lpa)<br>
	<input type="number" name="package"><p><br>

	<h4>FAMILY BACKGROUND</h4>
	Family Business?<br>
	<input type="radio" name="familyBusiness" value="Yes" checked>Yes<br>
    <input type="radio" name="familyBusiness" value="No">No<p>
	Average Annual Income(lacs)<br>
	<input type="number" name="familyIncome"><p>

</form>
	
	<button type="submit" name="dataSubmit" form="nameform" value="Submit" class="button" style="vertical-align:" onclick="clicked(event)"><span>Submit</span></button>
		
	</h3></div>
	<footer><h5>@Made By: Divyansh Rastogi</h5></footer>
</center>
</body>
</html>

<script>
function clicked(e)
{
    alert("Data Submitted! Open SWI Prolog to know your Careers!");
}
</script>