<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="21008000">
	<Property Name="CCSymbols" Type="Str"></Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="NI.Project.Description" Type="Str"></Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Setup Msg Strategy.lvlib" Type="Library" URL="../Setup Msg Strategy/Setup Msg Strategy.lvlib"/>
		<Item Name="Teardown Msg Strategy.lvlib" Type="Library" URL="../Teardown Msg Strategy/Teardown Msg Strategy.lvlib"/>
		<Item Name="Merge Error Msg Strategy.lvlib" Type="Library" URL="../Merge Error Msg Strategy/Merge Error Msg Strategy.lvlib"/>
		<Item Name="Override Error Msg Strategy.lvlib" Type="Library" URL="../Override Error Msg Strategy/Override Error Msg Strategy.lvlib"/>
		<Item Name="Create Queue Msg Strategy.lvlib" Type="Library" URL="../Create Queue Msg Strategy/Create Queue Msg Strategy.lvlib"/>
		<Item Name="Set Panel State Msg Strategy.lvlib" Type="Library" URL="../Set Panel State Msg Strategy/Set Panel State Msg Strategy.lvlib"/>
		<Item Name="jettl.lvlib" Type="Library" URL="../jettl/jettl.lvlib"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="usereventprio.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/usereventprio.ctl"/>
			</Item>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
