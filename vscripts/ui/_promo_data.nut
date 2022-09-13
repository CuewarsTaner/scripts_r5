global function InitPromoData
global function UpdatePromoData
global function IsPromoDataProtocolValid
global function GetPromoDataVersion
global function GetPromoDataLayout
global function GetPromoImage

global function UICodeCallback_MainMenuPromosUpdated

#if(DEV)
global function DEV_PrintPromoData
#endif //

//
//
const int PROMO_PROTOCOL = 2

struct
{
	MainMenuPromos&      promoData
	table<string, asset> imageMap
} file


void function InitPromoData()
{
	RequestMainMenuPromos() //

	var dataTable = GetDataTable( $"datatable/promo_images.rpak" )
	for ( int i = 0; i < GetDatatableRowCount( dataTable ); i++ )
	{
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) ).tolower()
		asset image = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "image" ) )
		if ( name != "" )
			file.imageMap[name] <- image
	}
}


void function UpdatePromoData()
{
	#if(DEV)
		if ( GetConVarBool( "mainMenuPromos_scriptUpdateDisabled" ) || GetCurrentPlaylistVarBool( "mainMenuPromos_scriptUpdateDisabled", false ) )
			return
	#endif //
	file.promoData = GetMainMenuPromos()
}


void function UICodeCallback_MainMenuPromosUpdated()
{
	printt( "Promos updated" )

	#if(DEV)
		if ( GetConVarInt( "mainMenuPromos_preview" ) == 1 )
			UpdatePromoData()
	#endif //
}


bool function IsPromoDataProtocolValid()
{
	return file.promoData.prot == PROMO_PROTOCOL
}


int function GetPromoDataVersion()
{
	return file.promoData.version
}


string function GetPromoDataLayout()
{
	return file.promoData.layout
}


asset function GetPromoImage( string identifier )
{
	identifier = identifier.tolower()

	asset image
	if ( identifier in file.imageMap )
		image = file.imageMap[identifier]
	else
		image = $"rui/promo/apex_title"

	return image
}

#if(DEV)
void function DEV_PrintPromoData()
{
	printt( "protocol:", file.promoData.prot )
	printt( "version: ", file.promoData.version )
	printt( "layout:  ", file.promoData.layout )
}
#endif //
