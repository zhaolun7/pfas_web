<template id="ExcelTemplate">
<div>
    <p>
        Basically, we need an excel file that contains two sheets: "<b>sample</b>" and "<b>blank</b>", <br/>which represent samples and blank samples for filtering, respectively.
    </p>
    <el-image style="width: 60%" :src="require('../assets/describe_1.png')" fit="scale-down"/>
    <p>
        The contents of the two sheets are similar. Every two columns represent a sample. 
        <br/>The first column is <b>the m/z mass of the sample</b> and the second column is the <b>intensity</b>. 
        <br/>You can get these two columns of data from <a href="https://www.waters.com/waters/en_US/MassLynx-Mass-Spectrometry-Software-/nav.htm?cid=513164&locale=en_US">MassLynx</a>.
    </p>
</div>
</template>