class profiles::serviceprovider {
	$spclustered = hiera('toas::sp::clustered')
	$spmachine = hiera('toas::sp:spmachine')
	class {'oi4sp': 
		spclustered => $spclustered, 
		spmachine => $spmachine
	}
}