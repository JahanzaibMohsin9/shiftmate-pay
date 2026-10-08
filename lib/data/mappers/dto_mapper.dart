abstract interface class DtoMapper<TDto, TDomain> {
  const DtoMapper();

  TDomain toDomain(TDto dto);

  TDto toDto(TDomain domain);
}
